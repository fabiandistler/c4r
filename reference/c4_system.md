# Create a system element for C4 diagrams

Create a system element for C4 diagrams

## Usage

``` r
c4_system(id, label = id, description = "", technology = "")
```

## Arguments

- id:

  Unique identifier for the system

- label:

  Display label for the system

- description:

  Optional description of the system

- technology:

  Optional technology information

## Value

A list representing a system element

## Examples

``` r
api <- c4_system("api", "API Gateway", "Handles all API requests", "Node.js")
```
