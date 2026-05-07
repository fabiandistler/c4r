# Changelog

## c4r (development version)

### Bug fixes

- [`use_c4r_readme()`](https://fabiandistler.github.io/c4r/reference/use_c4r_readme.md)
  now generates a `README.Rmd` that knits cleanly under
  `output: github_document`. The chunk exports the diagram to
  `man/figures/README-architecture.svg` via
  [`export_c4()`](https://fabiandistler.github.io/c4r/reference/export_c4.md)
  and embeds it with
  [`knitr::include_graphics()`](https://rdrr.io/pkg/knitr/man/include_graphics.html)
  so the diagram renders on GitHub, and the generated YAML sets
  `always_allow_html: true` as a safety net for the htmlwidget fallback
  when `DiagrammeRsvg` is not installed
  ([\#11](https://github.com/fabiandistler/c4r/issues/11)).
- [`use_c4r_vignette()`](https://fabiandistler.github.io/c4r/reference/use_c4r_vignette.md)
  now generates a vignette that builds cleanly under
  `devtools::build_vignettes()`. The bundled template previously called
  `c4_from_package(".")`, which failed because knitr knits vignettes
  with the working directory set to `vignettes/`
  ([\#12](https://github.com/fabiandistler/c4r/issues/12)).

### R-package toolchain integration

- New
  [`use_c4r()`](https://fabiandistler.github.io/c4r/reference/use_c4r.md)
  family of `usethis`-style scaffolding helpers:
  [`use_c4r()`](https://fabiandistler.github.io/c4r/reference/use_c4r.md),
  [`use_c4r_vignette()`](https://fabiandistler.github.io/c4r/reference/use_c4r_vignette.md),
  [`use_c4r_pkgdown()`](https://fabiandistler.github.io/c4r/reference/use_c4r_pkgdown.md),
  [`use_c4r_readme()`](https://fabiandistler.github.io/c4r/reference/use_c4r_readme.md),
  and
  [`use_c4r_action()`](https://fabiandistler.github.io/c4r/reference/use_c4r_action.md).
  They add an architecture vignette, a pkgdown article entry, an
  optional README chunk, and a GitHub Actions workflow respectively.
- New
  [`c4_from_package()`](https://fabiandistler.github.io/c4r/reference/c4_from_package.md)
  builds a `c4_builder` from an R package’s `DESCRIPTION` (and
  optionally `R/`), turning Imports/Depends into external systems and
  source files into containers.
- New `c4` knitr engine: write declarative `c4` chunks in R Markdown or
  Quarto. Engine is registered automatically on package load. See
  [`c4_knitr_engine()`](https://fabiandistler.github.io/c4r/reference/c4_knitr_engine.md)
  and
  [`c4_render_dsl()`](https://fabiandistler.github.io/c4r/reference/c4_render_dsl.md).
- New
  [`pkgdown_diagram()`](https://fabiandistler.github.io/c4r/reference/pkgdown_diagram.md)
  sets sensible width/height defaults for htmlwidget-based diagrams on
  Bootstrap 5 pkgdown sites; bundled `inst/pkgdown/extra.css` ensures
  responsive SVG sizing.
- New RStudio addins “Insert C4 chunk” and “Insert C4 template”
  ([`insert_c4_chunk()`](https://fabiandistler.github.io/c4r/reference/insert_c4_chunk.md),
  [`insert_c4_template()`](https://fabiandistler.github.io/c4r/reference/insert_c4_template.md)).

## c4r 0.1.0

### New features

- Added core C4 diagram creation functions:

  - [`c4_person()`](https://fabiandistler.github.io/c4r/reference/c4_person.md),
    [`c4_system()`](https://fabiandistler.github.io/c4r/reference/c4_system.md),
    [`c4_container()`](https://fabiandistler.github.io/c4r/reference/c4_container.md),
    [`c4_component()`](https://fabiandistler.github.io/c4r/reference/c4_component.md)
    for element creation
  - [`c4_external_system()`](https://fabiandistler.github.io/c4r/reference/c4_external_system.md)
    for external system elements
  - [`c4_rel()`](https://fabiandistler.github.io/c4r/reference/c4_rel.md)
    for relationships between elements
  - [`c4_context()`](https://fabiandistler.github.io/c4r/reference/c4_context.md),
    [`c4_container_diagram()`](https://fabiandistler.github.io/c4r/reference/c4_container_diagram.md),
    [`c4_component_diagram()`](https://fabiandistler.github.io/c4r/reference/c4_component_diagram.md)
    for complete diagrams

- Included multiple themes: default, dark, and blue

- Added comprehensive input validation and error handling
