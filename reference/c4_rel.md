# Create a relationship for C4 diagrams

Create a relationship for C4 diagrams

## Usage

``` r
c4_rel(from, to, label = "", technology = "")
```

## Arguments

- from:

  Source element ID

- to:

  Target element ID

- label:

  Description of the relationship

- technology:

  Optional technology used for the relationship

## Value

A list representing a relationship

## Examples

``` r
rel <- c4_rel("user", "system", "Uses", "HTTPS")
```
