# Create a C4 System Context Diagram

Create a C4 System Context Diagram

## Usage

``` r
c4_context(
  title = "System Context",
  person = list(),
  system = list(),
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

- system:

  List of system elements

- external_system:

  List of external system elements

- relationships:

  List of relationships between elements

- theme:

  Character string for color theme ("default", "dark", "blue") or a
  c4_theme object

- groups:

  List of group/boundary objects (optional)

## Value

A DiagrammeR graph object

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a simple system context diagram
c4_context(
  title = "E-Commerce System Context",
  person = list(
    list(id = "customer", label = "Customer", description = "Shops online")
  ),
  system = list(
    list(
      id = "ecommerce", label = "E-Commerce System",
      description = "Allows customers to buy products online"
    )
  ),
  relationships = list(
    list(from = "customer", to = "ecommerce", label = "Uses")
  )
)
} # }
```
