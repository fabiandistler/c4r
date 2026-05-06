# Build a C4 diagram from an R package

Reads `DESCRIPTION` (and optionally `R/`) and produces a `c4_builder`
representing the package's dependencies (Imports/Depends/Suggests). At
the container level, each `R/*.R` source file is rendered as a
container.

## Usage

``` r
c4_from_package(
  path = ".",
  level = c("context", "container"),
  include_suggests = TRUE,
  title = NULL
)
```

## Arguments

- path:

  Path to the package root. Defaults to the current directory.

- level:

  Diagram level: `"context"` (package as a system surrounded by its
  dependencies) or `"container"` (each `R/*.R` file as a container).

- include_suggests:

  Include packages from `Suggests` (rendered with a dashed line).
  Default: `TRUE`.

- title:

  Optional diagram title; defaults to the package name.

## Value

A `c4_builder` object. Pipe into
[`build_context()`](https://fabiandistler.github.io/c4r/reference/build_context.md)
or
[`build_container()`](https://fabiandistler.github.io/c4r/reference/build_container.md)
to render.

## Examples

``` r
if (FALSE) { # \dontrun{
# Diagram for the package in the current directory
c4_from_package() %>% build_context()

# Container-level diagram with R/ files as containers
c4_from_package(level = "container") %>% build_container()
} # }
```
