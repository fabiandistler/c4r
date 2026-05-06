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
