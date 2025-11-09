# Create relationship elements from a tibble or data frame

Create relationship elements from a tibble or data frame

## Usage

``` r
c4_rels_from_tibble(data)
```

## Arguments

- data:

  A tibble or data frame with columns: from, to, label, technology

## Value

A list of relationship elements

## Examples

``` r
if (FALSE) { # \dontrun{
library(tibble)
rels_df <- tribble(
  ~from,  ~to,     ~label,         ~technology,
  "user", "app",   "Uses",         "HTTPS",
  "app",  "db",    "Reads from",   "SQL"
)
rels <- c4_rels_from_tibble(rels_df)
} # }
```
