# Validate a C4 diagram for common issues

Checks for orphaned nodes, missing elements in relationships, duplicate
IDs, etc.

## Usage

``` r
validate_c4(elements, relationships)
```

## Arguments

- elements:

  Named list with person, system/container/component, external_system

- relationships:

  List of relationship elements

## Value

Invisible TRUE if valid, otherwise prints issues and returns FALSE

## Examples

``` r
if (FALSE) { # \dontrun{
result <- validate_c4(
  elements = list(
    person = list(c4_person("user", "User", "A user")),
    system = list(c4_system("app", "App", "An app"))
  ),
  relationships = list(c4_rel("user", "app", "Uses"))
)
} # }
```
