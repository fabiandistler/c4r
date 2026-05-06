# Add a c4r-powered vignette to a package

Creates `vignettes/architecture.Rmd` from a starter template and
registers c4r as a `Suggests` dependency.

## Usage

``` r
use_c4r_vignette(path = ".", template = "three_tier", overwrite = FALSE)
```

## Arguments

- path:

  Path to the package root. Defaults to the current directory.

- template:

  Starter template name (see
  [`c4_list_templates()`](https://fabiandistler.github.io/c4r/reference/c4_list_templates.md)).

- overwrite:

  Overwrite existing scaffolding files.

## Value

Invisibly returns the path to the created vignette.
