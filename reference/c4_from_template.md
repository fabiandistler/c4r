# Create a diagram from a template

Generate a C4 diagram using common architecture patterns

## Usage

``` r
c4_from_template(
  template = c("microservices", "monolith", "serverless", "three_tier", "data_pipeline"),
  ...
)
```

## Arguments

- template:

  Template name: "microservices", "monolith", "serverless", "three_tier"

- ...:

  Template-specific parameters

## Value

A DiagrammeR graph object

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a microservices architecture
diagram <- c4_from_template("microservices",
  services = c("api", "auth", "users"),
  databases = c("postgres", "redis"),
  message_queue = "rabbitmq"
)
} # }
```
