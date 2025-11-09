# Export C4 diagram to multiple formats

Convenience function to export a diagram to multiple formats at once

## Usage

``` r
export_c4_all(diagram, file, formats = c("png", "svg", "pdf"), ...)
```

## Arguments

- diagram:

  A DiagrammeR graph object

- file:

  Base filename (without extension)

- formats:

  Character vector of formats: "png", "svg", "pdf", "html"

- ...:

  Additional arguments passed to export_c4

## Value

Invisible vector of created file paths

## Examples

``` r
if (FALSE) { # \dontrun{
diagram <- c4_context(
  title = "My System",
  person = list(c4_person("user", "User", "A user")),
  system = list(c4_system("app", "App", "An app")),
  relationships = list(c4_rel("user", "app", "Uses"))
)

# Export to PNG, SVG, and PDF
export_c4_all(diagram, "architecture", formats = c("png", "svg", "pdf"))
} # }
```
