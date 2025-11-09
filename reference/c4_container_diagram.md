# Create a C4 Container Diagram

Create a C4 Container Diagram

## Usage

``` r
c4_container_diagram(
  title = "Container Diagram",
  person = list(),
  container = list(),
  external_system = list(),
  relationships = list(),
  theme = "default",
  groups = list()
)
```

## Arguments

- title:

  Character string for diagram title

- person:

  List of person elements

- container:

  List of container elements

- external_system:

  List of external system elements

- relationships:

  List of relationships between elements

- theme:

  Character string for color theme or a c4_theme object

- groups:

  List of group/boundary objects (optional)

## Value

A DiagrammeR graph object
