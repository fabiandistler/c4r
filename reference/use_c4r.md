# Scaffold c4r usage in an R package

Adds an architecture diagram skeleton to the current package: a
vignette, a pkgdown article entry, and (optionally) a chunk in
`README.Rmd`.

## Usage

``` r
use_c4r(
  path = ".",
  vignette = TRUE,
  pkgdown = TRUE,
  readme = FALSE,
  template = "three_tier",
  overwrite = FALSE
)
```

## Arguments

- path:

  Path to the package root. Defaults to the current directory.

- vignette:

  Add a starter vignette `vignettes/architecture.Rmd`.

- pkgdown:

  Add an "Architecture" entry to `_pkgdown.yml`.

- readme:

  Add a c4r chunk to `README.Rmd`.

- template:

  Starter template name (see
  [`c4_list_templates()`](https://fabiandistler.github.io/c4r/reference/c4_list_templates.md)).

- overwrite:

  Overwrite existing scaffolding files.

## Value

Invisibly returns the character vector of created/modified files.

## Details

This mirrors the `usethis::use_*` family. It expects to be run from the
root of an R package (where `DESCRIPTION` lives), or you can pass
`path`.

## Examples

``` r
if (FALSE) { # \dontrun{
# In an R package directory:
use_c4r()
use_c4r(readme = TRUE)
} # }
```
