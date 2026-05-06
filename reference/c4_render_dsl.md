# Render a c4 DSL body into a diagram

Parses the line-oriented DSL used by
[`c4_knitr_engine()`](https://fabiandistler.github.io/c4r/reference/c4_knitr_engine.md)
and dispatches to the appropriate diagram builder.

## Usage

``` r
c4_render_dsl(body, type = "context", title = "C4 Diagram", theme = "default")
```

## Arguments

- body:

  Character string containing the DSL body.

- type:

  Diagram type: `"context"`, `"container"`, or `"component"`.

- title:

  Diagram title.

- theme:

  Theme name.

## Value

A DiagrammeR htmlwidget.
