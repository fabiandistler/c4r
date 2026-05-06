# Integrating c4r with the R package toolchain

c4r is designed to slot into the existing R package-development
toolchain (devtools, usethis, roxygen2, knitr/rmarkdown, pkgdown,
RStudio, GitHub Actions). This vignette walks through each integration
point.

## 1. Scaffolding with `use_c4r()`

In any R package directory,
[`use_c4r()`](https://fabiandistler.github.io/c4r/reference/use_c4r.md)
adds:

- `vignettes/architecture.Rmd` — a starter article
- an entry under `articles:` in `_pkgdown.yml`
- (optionally) a c4r chunk in `README.Rmd`
- a copy of c4r’s pkgdown CSS

``` r

use_c4r(vignette = TRUE, pkgdown = TRUE, readme = FALSE)
```

This mirrors the `usethis::use_*` family. Run it once; re-running is
safe because the helpers are idempotent (use `overwrite = TRUE` to
replace).

## 2. A diagram from your package’s `DESCRIPTION`

[`c4_from_package()`](https://fabiandistler.github.io/c4r/reference/c4_from_package.md)
reads `DESCRIPTION` and turns Imports/Depends into external systems and
your package into a central system. At the container level, each `R/*.R`
file becomes a container.

``` r

c4_from_package(".") |> build_context()
c4_from_package(".", level = "container") |> build_container()
```

## 3. Declarative chunks via the `c4` knitr engine

c4r registers a knitr engine on load, so you can write diagrams in a
small DSL instead of R code:


    ```{=html}
    <div class="grViz html-widget html-fill-item" id="htmlwidget-ac96cb3ee4656e2e9ec3" style="width:700px;height:432.632880098888px;"></div>
    <script type="application/json" data-for="htmlwidget-ac96cb3ee4656e2e9ec3">{"x":{"diagram":"digraph {\n  graph [rankdir=TB, bgcolor=\"white\", fontname=\"Arial\"];\n  node [fontname=\"Arial\", fontsize=10];\n  edge [fontname=\"Arial\", fontsize=8];\n\n  label=\"My App\";\n  labelloc=t;\n  fontsize=16;\n\n\n  user [label=\"\\nEnd User\\n\", shape=box, style=\"filled,rounded\", margin=0.1, penwidth=2, fillcolor=\"#08427B\", fontcolor=\"white\"];\n  api [label=\"\\nAPI\\n\\nREST endpoint\\n[Service]\\n\", shape=box, style=\"filled,rounded\", margin=0.1, penwidth=2, fillcolor=\"#438DD5\", fontcolor=\"white\"];\n  db [label=\"\\nDatabase\\n\\nApp data\\n[Postgres]\\n\", shape=box, style=\"filled,rounded\", margin=0.1, penwidth=2, fillcolor=\"#438DD5\", fontcolor=\"white\"];\n\n  user -> api [label=\"Uses\\n[HTTPS]\", color=\"#666666\"];\n  api -> db [label=\"Reads/Writes\\n[SQL]\", color=\"#666666\"];\n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>
    ```

Renders as:

The engine works in both R Markdown and Quarto.

## 4. pkgdown polish

Diagrams returned from `c4_*_diagram()` are htmlwidgets. They render
fine inline, but pkgdown’s Bootstrap 5 layout works best when widgets
have an explicit width.
[`pkgdown_diagram()`](https://fabiandistler.github.io/c4r/reference/pkgdown_diagram.md)
sets sensible defaults:

``` r

c4_from_template("three_tier") |> pkgdown_diagram(height = "600px")
```

[`use_c4r_pkgdown()`](https://fabiandistler.github.io/c4r/reference/use_c4r_pkgdown.md)
also installs `pkgdown/extra.css` with responsive SVG sizing.

## 5. RStudio addins

When c4r is installed, two entries appear in the RStudio addin menu:

- **Insert C4 chunk** — inserts a starter `c4` knitr chunk at the
  cursor.
- **Insert C4 template** — prompts for a template name and inserts an R
  chunk that renders it.

## 6. Continuous rendering with GitHub Actions

[`use_c4r_action()`](https://fabiandistler.github.io/c4r/reference/use_c4r_action.md)
drops a reusable workflow into `.github/workflows/c4r-render.yaml`. On
every push it renders an SVG of
[`c4_from_package()`](https://fabiandistler.github.io/c4r/reference/c4_from_package.md)
and uploads it as a build artifact, so reviewers can inspect
architecture changes directly from a PR.
