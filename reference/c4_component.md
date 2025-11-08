# Create a component element for C4 diagrams

Create a component element for C4 diagrams

## Usage

``` r
c4_component(id, label = id, description = "", technology = "")
```

## Arguments

- id:

  Unique identifier for the component

- label:

  Display label for the component

- description:

  Optional description of the component

- technology:

  Optional technology information

## Value

A list representing a component element

## Examples

``` r
controller <- c4_component(
  "controller", "User Controller",
  "Handles user requests", "Spring Boot"
)
```
