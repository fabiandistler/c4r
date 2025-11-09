# Create an advanced relationship with additional visual properties

Create an advanced relationship with additional visual properties

## Usage

``` r
c4_rel_advanced(
  from,
  to,
  label = "",
  technology = "",
  type = c("sync", "async", "request-response"),
  style = c("solid", "dashed", "dotted"),
  direction = c("forward", "back", "both", "none")
)
```

## Arguments

- from:

  Source element ID

- to:

  Target element ID

- label:

  Description of the relationship

- technology:

  Optional technology used

- type:

  Relationship type: "sync", "async", "request-response"

- style:

  Line style: "solid", "dashed", "dotted"

- direction:

  Arrow direction: "forward", "back", "both", "none"

## Value

A list representing an advanced relationship

## Examples

``` r
# Synchronous HTTP request
rel1 <- c4_rel_advanced("user", "api", "Makes request", "HTTPS",
                        type = "sync", style = "solid")

# Asynchronous message
rel2 <- c4_rel_advanced("api", "queue", "Publishes event", "RabbitMQ",
                        type = "async", style = "dashed")
```
