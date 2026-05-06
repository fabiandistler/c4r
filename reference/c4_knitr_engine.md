# Knitr engine for declarative C4 chunks

Registered automatically when c4r is loaded. In an R Markdown or Quarto
document you can write:

## Usage

``` r
c4_knitr_engine(options)
```

## Arguments

- options:

  A knitr chunk options list. Recognises `type` (one of `"context"`,
  `"container"`, `"component"`; default `"context"`), `title`, and
  `theme`.

## Value

Knitr-rendered output. Not called directly.

## Details

    ```{c4, type="container", title="My App"}
    person: user "End User"
    container: api "API" [Service]
    rel: user -> api "Uses"
    ```

Supported lines (one per element):

- `person: <id> "<label>" "<description>"`

- `system: <id> "<label>" "<description>" [<technology>]`

- `container: <id> "<label>" "<description>" [<technology>]`

- `component: <id> "<label>" "<description>" [<technology>]`

- `external: <id> "<label>" "<description>"`

- `rel: <from> -> <to> "<label>" [<technology>]`
