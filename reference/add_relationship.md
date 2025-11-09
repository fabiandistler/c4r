# Add a relationship to the builder

Add a relationship to the builder

## Usage

``` r
add_relationship(
  builder,
  from,
  to,
  label = "",
  technology = "",
  type = NULL,
  style = NULL
)
```

## Arguments

- builder:

  A c4_builder object

- from:

  Source element ID

- to:

  Target element ID

- label:

  Relationship description

- technology:

  Technology/protocol used

- type:

  Relationship type (for advanced relationships)

- style:

  Line style (for advanced relationships)

## Value

Updated builder object
