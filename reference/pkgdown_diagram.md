# Render a C4 diagram tuned for pkgdown sites

Wraps a diagram object (or htmlwidget) so that it fills the available
Bootstrap 5 column width and respects a fixed pixel height. Diagrams
returned by
[`c4_context()`](https://fabiandistler.github.io/c4r/reference/c4_context.md)
and friends already render inline in Rmarkdown/Quarto, but their default
width is unbounded and looks awkward on a pkgdown page; this helper sets
sensible defaults.

## Usage

``` r
pkgdown_diagram(diagram, height = "500px", width = "100%")
```

## Arguments

- diagram:

  A DiagrammeR htmlwidget (output of
  [`c4_context()`](https://fabiandistler.github.io/c4r/reference/c4_context.md)
  etc.).

- height:

  CSS height for the diagram container (e.g. `"500px"`).

- width:

  CSS width for the diagram container (default `"100%"`).

## Value

The diagram with width/height set, ready for printing.

## Examples

``` r
if (FALSE) { # \dontrun{
diagram <- c4_from_template("three_tier")
pkgdown_diagram(diagram, height = "600px")
} # }
```
