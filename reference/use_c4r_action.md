# Add a GitHub Actions workflow that renders c4r diagrams

Copies a reusable workflow to `.github/workflows/c4r-render.yaml`. The
workflow runs on every push, renders an SVG from
`inst/architecture/diagram.R`, and uploads it as a build artifact.

## Usage

``` r
use_c4r_action(path = ".", overwrite = FALSE)
```

## Arguments

- path:

  Path to the package root. Defaults to the current directory.

- overwrite:

  Overwrite existing scaffolding files.

## Value

Invisibly returns the path to the workflow file.
