# ROOMBA — Wartungs-Katalog

Wiederkehrende, eng abgegrenzte Wartungsläufe für dieses Paket.
Pro Lauf wird **genau ein** Job ausgeführt.

## Regeln

- **Ein Job pro Lauf.** Kein Bündeln, kein "noch schnell dies mit".
- **Branch für PR-Jobs:** `roomba/[job]-[YYYY-MM-DD]`.
  Läuft der Job in einer Umgebung, die einen Branch vorgibt (z. B. eine
  gemanagte Claude-Code-Session), gilt der vorgegebene Branch; der
  gewünschte Name wird dann im Report vermerkt.
- **Klein halten:** PR-Diff < 300 Zeilen.
- **Verhalten nie ändern.** Ausnahmen — und nur dort, wo es der Job-Zweck
  verlangt: `doc-drift`, `dead-code`, `test-flakiness`.
- **Report-Jobs erzeugen keinen Code-Change**, nur ein Dokument unter
  `roomba/reports/`.
- **Jeder Lauf** aktualisiert unten das „zuletzt gelaufen"-Datum und nennt
  den nächsten fälligen Job.

## Katalog

| # | Job | Beschreibung | Output | Cooldown | Zuletzt gelaufen | Nächste Fälligkeit |
|---|-----|--------------|--------|----------|------------------|--------------------|
| 1 | `deps-audit` | Veraltete/verwundbare Dependencies (`DESCRIPTION`, GitHub Actions), Empfehlung je Fund mit Breaking-Change-Risiko | Report | 7 d | 2026-08-25 | 2026-09-01 |
| 2 | `doc-drift` | README, Vignetten und Roxygen-Docstrings gegen tatsächliches Verhalten des Codes prüfen | PR | 14 d | – | fällig |
| 3 | `dead-code` | Ungenutzte Funktionen, Exporte, Imports — Nachweis jeweils über Referenzsuche über `R/`, `tests/`, `vignettes/`, `inst/`, `NAMESPACE` | PR | 14 d | – | fällig |
| 4 | `error-edges` | API-/IO-Ränder ohne Fehlerbehandlung oder mit stillem Schlucken (`try()` ohne Auswertung, leeres `tryCatch`, ignorierte Rückgabewerte) | Report | 14 d | – | fällig |
| 5 | `test-flakiness` | Tests mit Zeit-, Zufalls- oder Netzabhängigkeit; fehlende Seeds, `Sys.time()`, ungeschützte Downloads | PR | 30 d | – | fällig |
| 6 | `security-footguns` | Hartkodierte Pfade, Secrets-Verdacht, Injection-Ränder, unsichere Defaults | **nur Report** | 14 d | – | fällig |
| 7 | `perf-quickwins` | Offensichtliche N+1-Muster und Kopier-Orgien; in R speziell unnötige `data.frame`/`tibble`-Kopien statt Referenzsemantik | Report | 30 d | – | fällig |

## Status

- **Zuletzt gelaufen:** `deps-audit` am **2026-08-25** → [Report](roomba/reports/2026-08-25-deps-audit.md)
- **Nächster fälliger Job:** **`doc-drift`** (#2, PR, noch nie gelaufen)
- `deps-audit` ist erneut fällig ab **2026-09-01**.

## Lauf-Historie

| Datum | Job | Ergebnis |
|-------|-----|----------|
| 2026-08-25 | `deps-audit` | [Report](roomba/reports/2026-08-25-deps-audit.md) — 8 Funde, kein CVE, 0 Code-Änderungen |
