# c4r (development version)

## R-package toolchain integration

* New `use_c4r()` family of `usethis`-style scaffolding helpers:
  `use_c4r()`, `use_c4r_vignette()`, `use_c4r_pkgdown()`,
  `use_c4r_readme()`, and `use_c4r_action()`. They add an architecture
  vignette, a pkgdown article entry, an optional README chunk, and a
  GitHub Actions workflow respectively.
* New `c4_from_package()` builds a `c4_builder` from an R package's
  `DESCRIPTION` (and optionally `R/`), turning Imports/Depends into
  external systems and source files into containers.
* New `c4` knitr engine: write declarative `c4` chunks in R Markdown or
  Quarto. Engine is registered automatically on package load. See
  `c4_knitr_engine()` and `c4_render_dsl()`.
* New `pkgdown_diagram()` sets sensible width/height defaults for
  htmlwidget-based diagrams on Bootstrap 5 pkgdown sites; bundled
  `inst/pkgdown/extra.css` ensures responsive SVG sizing.
* New RStudio addins "Insert C4 chunk" and "Insert C4 template"
  (`insert_c4_chunk()`, `insert_c4_template()`).

# c4r 0.1.0

## New features

* Added core C4 diagram creation functions:
  - `c4_person()`, `c4_system()`, `c4_container()`, `c4_component()` for element creation
  - `c4_external_system()` for external system elements
  - `c4_rel()` for relationships between elements
  - `c4_context()`, `c4_container_diagram()`, `c4_component_diagram()` for complete diagrams

* Included multiple themes: default, dark, and blue

* Added comprehensive input validation and error handling

