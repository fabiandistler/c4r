# Create a C4 Component Diagram

Create a C4 Component Diagram

## Usage

``` r
c4_component_diagram(
  title = "Component Diagram",
  component = list(),
  external_system = list(),
  relationships = list(),
  theme = "default",
  groups = list()
)
```

## Arguments

- title:

  Character string for diagram title

- component:

  List of component elements

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
