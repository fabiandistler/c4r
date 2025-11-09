# Create a deployment boundary group

Convenience function for creating deployment/infrastructure boundaries

## Usage

``` r
c4_deployment_boundary(id, label, members)
```

## Arguments

- id:

  Group identifier

- label:

  Group label (e.g., "AWS Cloud", "On-Premise")

- members:

  Element IDs within this deployment boundary

## Value

A group object

## Examples

``` r
cloud <- c4_deployment_boundary(
  "cloud",
  "Cloud Infrastructure",
  members = c("api", "db", "queue")
)
```
