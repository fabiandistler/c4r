# ROOMBA Report — `deps-audit`

**Datum:** 2026-08-25
**Job:** #1 `deps-audit` (Output: Report, Cooldown 7 d)
**Scope:** `DESCRIPTION`, `NAMESPACE`, `R/`, `tests/`, `vignettes/`, `inst/`, `.github/workflows/`
**Code-Änderungen:** keine (Report-Job)

---

## Methodik und ihre Grenzen

In der Session-Umgebung ist **kein R installiert** und der Netzwerk-Egress zu
`cran.r-project.org` / `crandb.r-pkg.org` ist durch die Proxy-Policy blockiert
(403 auf CONNECT). Damit war Folgendes **nicht** möglich:

- `old.packages()` / `remotes::dev_package_deps()` gegen einen echten Repo-Snapshot
- ein vollständiger Ist/Soll-Versionsabgleich für alle 21 deklarierten Pakete
- `R CMD check` zur Gegenprobe

Der Audit ist deshalb **statisch**: Abgleich der deklarierten Dependencies gegen
die tatsächlich im Code aufgerufenen APIs, plus Websuche für einzelne
Versions-/Wartungsstände. Alles unten Behauptete ist entweder aus dem Repo
belegt (Datei:Zeile) oder als Websuch-Ergebnis markiert.

**Ergebnis vorab: keine bekannte Sicherheitslücke (CVE) in einer der
deklarierten Dependencies gefunden.** Die Funde sind Hygiene-, Gewichts- und
Wartbarkeitsthemen.

---

## Dependency-Inventar

`DESCRIPTION` deklariert: `Depends: R (>= 4.1.0)`, 9 `Imports`, 12 `Suggests`.
**Keine einzige Untergrenze außer bei `testthat (>= 3.0.0)`.**

### Imports — tatsächliche Nutzung in `R/`

| Paket | Aufrufe | Genutzte API | Bewertung |
|-------|---------|--------------|-----------|
| `cli` | 116 | `cli_abort`, `cli_warn`, `cli_alert_*`, `cli_h2/h3`, `cli_text`, `cli_ul` | Kern-Dependency, gerechtfertigt |
| `glue` | 38 | `glue` | gerechtfertigt |
| `purrr` | 27 | `map`, `map_chr`, `map_dfr`, `pmap`, `pmap_chr` | gerechtfertigt, aber `map_dfr` ist superseded → **F-2** |
| `tibble` | 9 | `tibble` | gerechtfertigt (Rückgabetyp öffentlicher API) |
| `rlang` | 6 | `caller_arg`, `caller_env` | gerechtfertigt |
| `dplyr` | 4 | **nur** `bind_rows` | schwer für einen Aufruf → **F-3** |
| `DiagrammeR` | 3 | `grViz` | gerechtfertigt (Kernzweck des Pakets) |
| `magrittr` | 1 | Re-Export `%>%` | öffentliche API, behalten → **F-7** |
| `stringr` | 1 | **nur** `str_replace_all` | für einen Aufruf entbehrlich → **F-4** |

### Suggests — tatsächliche Nutzung

| Paket | Fundort | Guard | Bewertung |
|-------|---------|-------|-----------|
| `knitr` | `R/zzz.R`, `R/knitr_engine.R`, Vignetten, `inst/` | `requireNamespace` ✓ | ok |
| `withr` | 10× in `tests/` | – | ok |
| `yaml` | `R/code_generation.R`, `tests/` | `requireNamespace` ✓ | ok |
| `rstudioapi` | `R/addin_insert.R` | `requireNamespace` + `isAvailable` ✓ | ok |
| `desc` | `R/from_package.R`, `R/use.R` | `requireNamespace` ✓ | ok |
| `rsvg` | `R/export.R` | `requireNamespace` ✓ | ok |
| `DiagrammeRsvg` | `R/export.R` | `requireNamespace` ✓ | ok, aber unmaintained → **F-5** |
| `htmlwidgets` | `R/export.R` (`saveWidget`) | ⚠️ **kein Guard** | → **F-6** |
| `rmarkdown` | Vignetten, `inst/` | – (VignetteBuilder) | ok |
| `spelling` | `tests/` | – | ok |
| `testthat` | Testinfrastruktur | – | ok |
| `usethis` | **nirgends aufgerufen** | – | ungenutzt → **F-1** |

---

## Funde

Sortiert nach Aufwand-zu-Nutzen. „Breaking-Change-Risiko" bewertet das Risiko
für *Nutzer dieses Pakets*, wenn die Empfehlung umgesetzt wird.

---

### F-1 · `usethis` steht in `Suggests`, wird aber nie aufgerufen

**Nachweis.** Die beiden `usethis::`-Treffer in `R/` sind kein Code:

- `R/use.R:8` — Roxygen-Kommentar: `#' This mirrors the \`usethis::use_*\` family.`
- `R/use.R:102` — Text in einer CLI-Meldung: `` cli::cli_alert_info("... Run {.code usethis::use_pkgdown()} first.") ``

Dazu ein Prosa-Treffer in `vignettes/integrations.Rmd:32`. Kein einziger
tatsächlicher Funktionsaufruf, kein `requireNamespace("usethis")`.

**Empfehlung.** `usethis` aus `Suggests` entfernen. Die `use_c4r_*()`-Familie
in `R/use.R` ist eine Eigenimplementierung, die `usethis` bewusst *nicht*
braucht — die Erwähnungen sind Dokumentation, keine Abhängigkeit.

**Breaking-Change-Risiko: keine.** `Suggests` wird nicht geladen; die
CLI-Meldung ist ein String und funktioniert unverändert.

---

### F-2 · `purrr::map_dfr` ist seit purrr 1.0.0 superseded (4 Aufrufe)

**Nachweis.**

- `R/helpers.R:22` — `person_nodes <- purrr::map_dfr(person, ~ {`
- `R/helpers.R:42` — `system_nodes <- purrr::map_dfr(system_or_container, ~ {`
- `R/helpers.R:56` — `external_nodes <- purrr::map_dfr(external_system, ~ {`
- `R/helpers.R:87` — `purrr::map_dfr(relationships, ~ {`

Laut purrr-Doku wurden `map_dfr()`/`map_dfc()` in **purrr 1.0.0** superseded,
u. a. weil sie intern `dplyr::bind_rows()` verwenden und damit eine
dplyr-Installation erzwingen. Empfohlener Ersatz: `map(x, f) |> list_rbind()`
(basiert auf `vctrs::vec_rbind()`, ohne dplyr). Superseded heißt: bleibt
erhalten, bekommt aber nur noch kritische Bugfixes.
([purrr-Referenz](https://purrr.tidyverse.org/reference/map_dfr.html))

**Empfehlung.** Auf `purrr::map()` + `purrr::list_rbind()` umstellen.
`list_rbind()` gibt es ab purrr 1.0.0 — dann gehört `purrr (>= 1.0.0)` in
`Imports` (siehe F-8).

**Breaking-Change-Risiko: niedrig, aber nicht null.** `vec_rbind()` ist bei
Typkonflikten zwischen Spalten strenger als `bind_rows()`. Hier werden in allen
vier Fällen gleichförmige 1-Zeilen-Tibbles mit festem Schema erzeugt, also
sollte das Ergebnis identisch sein. Vor dem Merge einmal `devtools::test()`
plus einen Blick auf die Snapshot-Tests laufen lassen. Kein Effekt auf die
öffentliche API.

---

### F-3 · `dplyr` in `Imports` für genau eine Funktion

**Nachweis.** Alle 4 `dplyr::`-Aufrufe sind `bind_rows`:
`R/validation.R:255`, `R/helpers.R:31`, `R/helpers.R:51`, `R/helpers.R:65`.

`dplyr` zieht einen der schwersten Abhängigkeitsbäume im Tidyverse nach
(u. a. `vctrs`, `pillar`, `tidyselect`, `lifecycle`, `generics`, `R6`, `cli`,
`glue`, `magrittr`, `rlang`, `tibble`) und ist mit C++-Code kompilierpflichtig.
Für ein Paket, dessen Kern DOT-Strings erzeugt, ist das viel Gewicht für einen
Aufruf.

**Empfehlung.** Zusammen mit F-2 behandeln: Wenn `map_dfr` durch
`purrr::list_rbind()` ersetzt wird, bleiben nur die 4 direkten `bind_rows()`
übrig. Die lassen sich ebenfalls durch `purrr::list_rbind(list(a, b))` oder
`vctrs::vec_rbind()` ersetzen — danach kann `dplyr` aus `Imports` verschwinden.
Reihenfolge: erst F-2, dann F-3; einzeln umgesetzt bringt F-3 nichts, weil
`map_dfr` dplyr ohnehin erzwingt.

**Breaking-Change-Risiko: niedrig.** Interne Verwendung, kein Export berührt.
Gleiche Typstrenge-Anmerkung wie F-2. **Nutzen ist real:** ein Import weniger,
deutlich kürzere Installationskette für Nutzer.

---

### F-4 · `stringr` in `Imports` für einen einzigen `str_replace_all`

**Nachweis.** `R/helpers.R:286`:

```r
stringr::str_replace_all(string, '"', '\\\\"')
```

Das ist das einzige `stringr::` im gesamten Paket — ein reines
Escaping-Hilfsmittel für Anführungszeichen in DOT-Labels.

**Empfehlung.** Ersetzbar durch base R:

```r
gsub('"', '\\\\"', string, fixed = TRUE)
```

`fixed = TRUE` ist hier wichtig und macht das Ergebnis sogar eindeutiger als
die Regex-Variante. Danach `stringr` aus `Imports` streichen.

**Breaking-Change-Risiko: niedrig.** Eine Funktion, ein Aufruf, klar
testbares Verhalten. Vor dem Merge gezielt gegen Labels mit `"`, `\` und
Kombinationen testen — das Escaping landet in generiertem DOT-Code, ein Fehler
dort erzeugt kaputte Diagramme statt eines Fehlers. Wenn es dabei keine
bestehende Testabdeckung gibt, ist das ein Fund für Job #3/#5, nicht für hier.

---

### F-5 · `DiagrammeRsvg` ist seit 2016 unverändert und trägt den gesamten Export-Pfad

**Nachweis.** `R/export.R:51` schützt den Aufruf korrekt:

```r
if (!requireNamespace("DiagrammeRsvg", quietly = TRUE)) {
```

Aber `DiagrammeRsvg::export_svg()` ist die einzige Quelle für SVG in diesem
Paket, und PNG/PDF (`rsvg::rsvg_png` / `rsvg::rsvg_pdf`, `R/export.R:71`)
hängen an dessen Output. Websuche: `DiagrammeRsvg` steht bei **Version 0.1,
publiziert 2016-02-02**, Maintainer Richard Iannone, seither ohne Release.
Nicht archiviert, also derzeit installierbar.
([CRAN](https://cran.rstudio.com/web/packages/DiagrammeRsvg/index.html),
[GitHub](https://github.com/rich-iannone/DiagrammeRsvg))

**Empfehlung.** Kein Handlungsbedarf jetzt — nur bewusst als Risiko führen:
Fällt das Paket von CRAN, verliert `export_c4()` alles außer HTML. Ein
Fallback über `DiagrammeR::grViz()` + direkten Graphviz-Aufruf wäre der
Notausgang, ist aber deutlich mehr als ein Roomba-Job. Als Beobachtungspunkt
bei jedem `deps-audit`-Lauf mitprüfen.

**Breaking-Change-Risiko der Empfehlung: keine** (keine Änderung).
**Risiko bei Nichtstun: niedrig, aber mit hohem Impact,** falls es eintritt.

---

### F-6 · `htmlwidgets::saveWidget()` wird ohne `requireNamespace`-Guard aufgerufen

**Nachweis.** `htmlwidgets` steht in `Suggests`, wird in `R/export.R`
(`saveWidget`) verwendet. In `R/export.R` gibt es Guards für `DiagrammeRsvg`
(Zeile 51) und `rsvg` (Zeile 71) — **für `htmlwidgets` findet sich keiner**;
in der gesamten Guard-Liste des Pakets taucht `htmlwidgets` nicht auf.

Damit bricht der HTML-Export mit einem rohen
`there is no package called 'htmlwidgets'` statt mit der freundlichen
`cli_abort`-Meldung, die die anderen beiden Pfade liefern. Formal ist das ein
`R CMD check`-Thema: ein Paket darf `Suggests` nur bedingt verwenden.

In der Praxis ist `htmlwidgets` eine harte Dependency von `DiagrammeR`
(`Imports`), ist also faktisch immer installiert — deshalb fällt es nicht auf.

**Empfehlung.** Zwei saubere Optionen:

1. Guard analog zu Zeile 51/71 ergänzen (konsistent mit dem restlichen File), **oder**
2. `htmlwidgets` von `Suggests` nach `Imports` verschieben — ehrlicher, weil es
   über `DiagrammeR` ohnehin immer da ist, und der einzige Weg, den Aufruf ganz
   ohne Guard zu rechtfertigen.

Empfehlung dieses Reports: **Option 1**, weil sie das File in sich stimmig
macht und den Dependency-Umfang nicht erhöht.

**Breaking-Change-Risiko: keine** — der Pfad ändert sich nur im
Fehlerfall, der heute praktisch nie eintritt. Die Umsetzung selbst ist eine
Verhaltensänderung (andere Fehlermeldung) und gehört damit **nicht** in einen
Report-Job; sie ist als eigener kleiner PR zu fahren oder von Job #4
(`error-edges`) mitzunehmen, wo sie thematisch hingehört.

---

### F-7 · `magrittr` bleibt — trotz `R (>= 4.1.0)`

**Nachweis.** `NAMESPACE` exportiert `%>%` (`export("%>%")`,
`importFrom(magrittr,"%>%")`), Quelle ist `R/utils-pipe.R`. Gleichzeitig setzt
das Paket R ≥ 4.1.0 voraus und nutzt intern bereits den nativen Pipe
(`R/helpers.R:159`, `R/helpers.R:181`).

**Empfehlung.** `magrittr` **behalten**. `%>%` ist ein dokumentierter Export;
ein Entfernen bräche Nutzer-Code, der `library(c4r)` lädt und `%>%` erwartet.
Der Fund ist hier nur festgehalten, damit er in künftigen Läufen nicht erneut
als „unnötige Ein-Funktions-Dependency" aufschlägt — im Unterschied zu F-3/F-4
ist er es *nicht*.

**Breaking-Change-Risiko einer Entfernung: hoch.** Nicht tun.

---

### F-8 · Keine Versions-Untergrenzen, obwohl der Code moderne APIs verlangt

**Nachweis.** `DESCRIPTION` deklariert 9 `Imports` **komplett ohne `(>= ...)`**.
Der Code verlangt aber nachweislich:

| API | Fundort | Erfordert mindestens |
|-----|---------|----------------------|
| `cli::cli_abort`, `cli::cli_warn` | 15 Dateien in `R/` | `cli (>= 3.0.0)` |
| `rlang::caller_arg` | `R/helpers.R:296,310,324` | `rlang (>= 1.0.0)` |
| `purrr::list_rbind` | *nach* Umsetzung von F-2 | `purrr (>= 1.0.0)` |

Ohne Untergrenzen installiert ein Nutzer mit älterem `cli` das Paket
erfolgreich und bekommt erst zur Laufzeit `could not find function
"cli_abort"` — und zwar im Fehlerpfad, also genau dann, wenn er ohnehin schon
ein Problem hat.

**Empfehlung.** Mindestens die beiden belegten Grenzen nachtragen:

```
Imports:
    cli (>= 3.0.0),
    ...
    rlang (>= 1.0.0),
```

`purrr (>= 1.0.0)` kommt zusammen mit F-2 dazu. Für die übrigen (`glue`,
`tibble`, `DiagrammeR`, `magrittr`) ist keine Grenze belegbar — dort bewusst
keine erfinden.

**Breaking-Change-Risiko: keine für bestehende Nutzer** mit aktuellen
Paketen. Nutzer mit tatsächlich veraltetem `cli`/`rlang` bekommen die Meldung
künftig bei der Installation statt im Fehlerfall — das ist der Zweck.

---

### F-9 · GitHub Actions: veraltete Majors, ein pin auf Patch-Ebene

**Nachweis** (`.github/workflows/`):

| Action | Verwendet | Fundort | Anmerkung |
|--------|-----------|---------|-----------|
| `actions/checkout` | `@v4` | alle 4 Workflows | Websuche: aktuell **v6** (v5 und v6 existieren) |
| `actions/upload-artifact` | `@v4` | `test-coverage.yaml:63` | Websuche: aktuell **v7**; v6 läuft auf Node 24 |
| `JamesIves/github-pages-deploy-action` | `@v4.5.0` | `pkgdown.yaml:49` | auf eine **Patch**-Version gepinnt, kein Major-Tag |
| `codecov/codecov-action` | `@v5` | `test-coverage.yaml:45` | aktuell |
| `r-lib/actions/*` | `@v2` | alle | aktuell (v2 ist der laufende Major) |

([checkout releases](https://github.com/actions/checkout/releases),
[upload-artifact releases](https://github.com/actions/upload-artifact/releases))

Die veralteten Node-Runtimes in `@v4` sind der praktische Druckpunkt: GitHub
schaltet alte Node-Versionen in Runnern irgendwann ab, dann brechen alle vier
Workflows gleichzeitig und ohne Vorwarnung durch eine Repo-Änderung.

**Empfehlung.** `actions/checkout` auf `@v5` oder `@v6` und
`actions/upload-artifact` auf `@v6`/`@v7` heben. Für
`github-pages-deploy-action` entweder auf `@v4` (Major-Tag, bekommt Fixes) oder
bewusst auf einen Commit-SHA pinnen — der jetzige Zustand `@v4.5.0` ist der
schlechteste von beiden: er altert still und bekommt keine Sicherheitsfixes,
ohne dafür die Unveränderlichkeit eines SHA-Pins zu bieten.

**Breaking-Change-Risiko: niedrig für `checkout`** (v5/v6 sind für den
Standardfall drop-in). **Mittel für `upload-artifact`:** v5 hat das
Artifact-Verhalten geändert (u. a. keine impliziten Merges gleichnamiger
Uploads mehr) — `test-coverage.yaml:63` lädt Testergebnisse hoch, das ist vor
dem Merge einmal an einem echten Lauf zu prüfen. Kein Risiko für Paketnutzer,
nur für CI.

Ob dieses Repo ganz auf **SHA-Pinning** für Third-Party-Actions gehen sollte,
ist eine Supply-Chain-Frage und gehört zu **Job #6 `security-footguns`**, nicht
hierher.

---

### F-10 · `covr` wird in CI installiert, steht aber in keinem `Suggests`

**Nachweis.** `.github/workflows/test-coverage.yaml:27` installiert
`any::covr, any::xml2, any::roxygen2`. In `DESCRIPTION` kommt keines der drei
vor (`grep covr\|roxygen2\|pkgdown DESCRIPTION` → leer). `roxygen2` ist über
`RoxygenNote: 7.3.3` immerhin implizit dokumentiert, `covr` nirgends.

**Empfehlung.** Kosmetisch — `covr` in `Suggests` aufnehmen (das tut
`usethis::use_coverage()` normalerweise selbst), damit der Coverage-Lauf
lokal reproduzierbar ist, ohne die CI-YAML lesen zu müssen. Bewusst
niedrig priorisiert.

**Breaking-Change-Risiko: keine.**

---

## Zusätzliche Beobachtung außerhalb des Job-Scopes

Der `R-CMD-check`-Matrix (`.github/workflows/R-CMD-check.yaml:20-25`) testet
`release`, `devel` und `oldrel-1` — Stand August 2026 also grob R 4.6/4.5.
`DESCRIPTION` verspricht aber `R (>= 4.1.0)`. **Die deklarierte Untergrenze
wird von keinem CI-Lauf abgedeckt.**

Die Grenze 4.1.0 ist inhaltlich korrekt gewählt und belegt — der native Pipe
in `R/helpers.R:159` und `R/helpers.R:181` braucht genau R 4.1. Sie ist nur
unverifiziert: nichts würde auffallen, wenn ein künftiger Commit versehentlich
eine R-4.2-API einführt.

Das ist eine CI-Konfigurationsfrage, kein Dependency-Fund, deshalb hier nur als
Notiz und ohne Fund-Nummer. Falls es aufgegriffen wird: entweder eine
`{os: ubuntu-latest, r: '4.1'}`-Zeile in die Matrix, oder die Untergrenze
bewusst auf das anheben, was tatsächlich getestet wird.

---

## Zusammenfassung

| Fund | Thema | Empfehlung | Breaking-Change-Risiko |
|------|-------|------------|------------------------|
| F-1 | `usethis` ungenutzt in `Suggests` | entfernen | keine |
| F-2 | `purrr::map_dfr` superseded (4×) | → `map()` + `list_rbind()` | niedrig |
| F-3 | `dplyr` nur für `bind_rows` | nach F-2 aus `Imports` entfernen | niedrig |
| F-4 | `stringr` nur für `str_replace_all` | → `gsub(..., fixed = TRUE)` | niedrig |
| F-5 | `DiagrammeRsvg` seit 2016 ohne Release | beobachten, nichts tun | keine (Impact bei Eintritt: hoch) |
| F-6 | `htmlwidgets` ohne `requireNamespace`-Guard | Guard ergänzen | keine (gehört zu Job #4) |
| F-7 | `magrittr` Ein-Funktions-Dependency | **behalten** | Entfernung wäre hoch |
| F-8 | keine Versions-Untergrenzen | `cli (>= 3.0.0)`, `rlang (>= 1.0.0)` | keine |
| F-9 | GH Actions `checkout@v4`, `upload-artifact@v4` | Majors heben | niedrig / mittel (nur CI) |
| F-10 | `covr` nicht in `Suggests` | nachtragen | keine |

**Keine CVE-Treffer.** Kein Paket im Baum ist archiviert oder als verwundbar
gemeldet.

Sinnvollstes Bündel für einen späteren, eigenen PR (nicht diesen Report-Job):
**F-1 + F-2 + F-3 + F-4 + F-8** — das ergibt zusammen `dplyr`, `stringr` und
`usethis` weniger, entfernt die superseded API und macht die
Versionsanforderungen ehrlich. Diff-Schätzung deutlich unter 300 Zeilen, im
Wesentlichen `R/helpers.R`, `R/validation.R` und `DESCRIPTION`. Weil dabei
Code angefasst wird, gehört das nicht in `deps-audit` (Report-Job), sondern in
einen separat beauftragten Lauf.

---

## Lauf-Metadaten

- **Branch:** `claude/roomba-deps-audit-svkfl9`. Der Katalog sieht
  `roomba/deps-audit-2026-08-25` vor; die Session-Umgebung gibt den
  Branch-Namen bindend vor, deshalb die Abweichung.
- **Geänderte Dateien:** `ROOMBA.md` (neu), dieser Report (neu),
  `.Rbuildignore` (zwei Zeilen, damit `R CMD check` die neuen Dateien nicht
  als Fremdkörper im Paket-Tarball meldet). Kein Paket-Code berührt.
- **Nächster fälliger Job:** `doc-drift` (#2).
- **`deps-audit` erneut fällig:** 2026-09-01.
