# Check C4 elements for common issues

Quick validation of elements before creating a diagram

## Usage

``` r
check_c4_elements(...)
```

## Arguments

- ...:

  Named arguments for different element types (person, system,
  container, component, external_system, relationships)

## Value

Invisible TRUE if valid, otherwise prints issues

## Examples

``` r
if (FALSE) { # \dontrun{
check_c4_elements(
  person = list(c4_person("user", "User", "A user")),
  system = list(c4_system("app", "App", "An app")),
  relationships = list(c4_rel("user", "app", "Uses"))
)
} # }
```
