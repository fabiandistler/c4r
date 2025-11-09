# Create a C4 diagram builder

Initialize a fluent builder for creating C4 diagrams with a chainable
API

## Usage

``` r
c4_builder(title = "System Diagram", theme = "default")
```

## Arguments

- title:

  Diagram title

- theme:

  Theme name or c4_theme object

## Value

A c4_builder object

## Examples

``` r
if (FALSE) { # \dontrun{
diagram <- c4_builder() %>%
  set_title("E-Commerce System") %>%
  set_theme("blue") %>%
  add_person("customer", "Customer", "Buys products") %>%
  add_system("shop", "Shop System", "E-commerce platform", "React") %>%
  add_relationship("customer", "shop", "Browses", "HTTPS") %>%
  build_context()
} # }
```
