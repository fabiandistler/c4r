# Add a c4r article entry to `_pkgdown.yml`

Idempotently appends an "Architecture" entry under `articles:` so that
the vignette appears on the pkgdown site.

## Usage

``` r
use_c4r_pkgdown(path = ".")
```

## Arguments

- path:

  Path to the package root. Defaults to the current directory.

## Value

Invisibly returns the path to `_pkgdown.yml`.
