# Generate R code from diagram elements

Convert diagram elements back to R code for sharing or documentation

## Usage

``` r
diagram_to_code(
  elements,
  relationships,
  title = "System Diagram",
  theme = "default",
  diagram_type = "context"
)
```

## Arguments

- elements:

  Named list of elements (person, system, container, etc.)

- relationships:

  List of relationships

- title:

  Diagram title

- theme:

  Theme name

- diagram_type:

  Type of diagram: "context", "container", "component"

## Value

Character string with R code

## Examples

``` r
if (FALSE) { # \dontrun{
elements <- list(
  person = list(c4_person("user", "User", "A user")),
  system = list(c4_system("app", "App", "An app"))
)
rels <- list(c4_rel("user", "app", "Uses"))

code <- diagram_to_code(elements, rels, "My System", "default", "context")
cat(code)
} # }
```
