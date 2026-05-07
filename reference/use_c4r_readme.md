# Add a c4r chunk to `README.Rmd`

Appends a code chunk to the README that renders an architecture diagram.
If `README.Rmd` does not exist, it is created with a minimal header.

## Usage

``` r
use_c4r_readme(path = ".", overwrite = FALSE)
```

## Arguments

- path:

  Path to the package root. Defaults to the current directory.

- overwrite:

  Overwrite existing scaffolding files.

## Value

Invisibly returns the path to `README.Rmd`.

## Details

The chunk exports the diagram to `man/figures/README-architecture.svg`
via
[`export_c4()`](https://fabiandistler.github.io/c4r/reference/export_c4.md)
and embeds it with
[`knitr::include_graphics()`](https://rdrr.io/pkg/knitr/man/include_graphics.html)
so it renders on GitHub. This requires the suggested package
DiagrammeRsvg; without it the chunk falls back to the htmlwidget, which
is why the generated YAML sets `always_allow_html: true`.
