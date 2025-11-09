# Export C4 diagram to various formats

Export a C4 diagram to PNG, SVG, PDF, or HTML format

## Usage

``` r
export_c4(
  diagram,
  file,
  format = c("png", "svg", "pdf", "html"),
  width = NULL,
  height = NULL,
  dpi = 300
)
```

## Arguments

- diagram:

  A DiagrammeR graph object (output from c4_context, etc.)

- file:

  Output file path (without extension)

- format:

  Output format: "png", "svg", "pdf", or "html"

- width:

  Width in pixels (for PNG) or inches (for PDF)

- height:

  Height in pixels (for PNG) or inches (for PDF)

- dpi:

  DPI for PNG output (default: 300)

## Value

Invisible path to created file

## Examples

``` r
if (FALSE) { # \dontrun{
diagram <- c4_context(
  title = "My System",
  person = list(c4_person("user", "User", "A user")),
  system = list(c4_system("app", "App", "An app")),
  relationships = list(c4_rel("user", "app", "Uses"))
)

# Export to PNG
export_c4(diagram, "architecture", format = "png")

# Export to SVG
export_c4(diagram, "architecture", format = "svg")
} # }
```
