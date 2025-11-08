# Create an external system element for C4 diagrams

Create an external system element for C4 diagrams

## Usage

``` r
c4_external_system(id, label = id, description = "")
```

## Arguments

- id:

  Unique identifier for the external system

- label:

  Display label for the external system

- description:

  Optional description of the external system

## Value

A list representing an external system element

## Examples

``` r
payment <- c4_external_system(
  "payment", "Payment Gateway",
  "Processes credit card payments"
)
```
