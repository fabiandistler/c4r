# Create a person element for C4 diagrams

Create a person element for C4 diagrams

## Usage

``` r
c4_person(id, label = id, description = "")
```

## Arguments

- id:

  Unique identifier for the person

- label:

  Display label for the person

- description:

  Optional description of the person's role

## Value

A list representing a person element

## Examples

``` r
customer <- c4_person("customer", "Customer", "A person who buys products")
```
