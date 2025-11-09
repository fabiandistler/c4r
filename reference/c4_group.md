# Create a visual group/boundary for C4 diagrams

Groups allow you to visually cluster related elements within a boundary

## Usage

``` r
c4_group(
  id,
  label = id,
  members = character(0),
  style = c("solid", "dashed", "dotted", "bold"),
  color = NULL,
  bg = NULL
)
```

## Arguments

- id:

  Unique identifier for the group

- label:

  Display label for the group

- members:

  Character vector of element IDs to include in this group

- style:

  Border style: "solid", "dashed", "dotted", "bold"

- color:

  Border color (optional, uses theme default if not specified)

- bg:

  Background color for the group (optional, transparent if not
  specified)

## Value

A list representing a group element

## Examples

``` r
# Create a group for AWS cloud services
aws_group <- c4_group(
  "aws",
  "AWS Cloud",
  members = c("api", "db", "cache"),
  style = "dashed"
)
```
