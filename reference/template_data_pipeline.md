# Data pipeline template

Data pipeline template

## Usage

``` r
template_data_pipeline(
  title = "Data Pipeline",
  sources = c("api", "files"),
  processing = c("etl"),
  storage = c("warehouse")
)
```

## Arguments

- title:

  Diagram title

- sources:

  Character vector of data sources

- processing:

  Character vector of processing components

- storage:

  Character vector of storage types
