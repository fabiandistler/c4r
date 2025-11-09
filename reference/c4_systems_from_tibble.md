# Create system elements from a tibble or data frame

Create system elements from a tibble or data frame

## Usage

``` r
c4_systems_from_tibble(data)
```

## Arguments

- data:

  A tibble or data frame with columns: id, label, description,
  technology

## Value

A list of system elements

## Examples

``` r
if (FALSE) { # \dontrun{
library(tibble)
systems_df <- tribble(
  ~id,   ~label,      ~description,        ~technology,
  "api", "API",       "REST API service",  "Node.js",
  "db",  "Database",  "Data storage",      "PostgreSQL"
)
systems <- c4_systems_from_tibble(systems_df)
} # }
```
