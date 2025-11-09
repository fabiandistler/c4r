# Get DOT notation from a C4 diagram

Extract the underlying DOT/Graphviz code from a diagram object

## Usage

``` r
c4_get_dot(diagram)
```

## Arguments

- diagram:

  A DiagrammeR graph object

## Value

Character string with DOT notation

## Examples

``` r
if (FALSE) { # \dontrun{
diagram <- c4_context(
  title = "My System",
  person = list(c4_person("user", "User", "A user")),
  system = list(c4_system("app", "App", "An app")),
  relationships = list(c4_rel("user", "app", "Uses"))
)

dot_code <- c4_get_dot(diagram)
cat(dot_code)
} # }
```
