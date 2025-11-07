# Export functions -------------------------------------------------------

#' Export C4 diagram to various formats
#'
#' Export a C4 diagram to PNG, SVG, PDF, or HTML format
#'
#' @param diagram A DiagrammeR graph object (output from c4_context, etc.)
#' @param file Output file path (without extension)
#' @param format Output format: "png", "svg", "pdf", or "html"
#' @param width Width in pixels (for PNG) or inches (for PDF)
#' @param height Height in pixels (for PNG) or inches (for PDF)
#' @param dpi DPI for PNG output (default: 300)
#' @return Invisible path to created file
#' @export
#' @examples
#' \dontrun{
#' diagram <- c4_context(
#'   title = "My System",
#'   person = list(c4_person("user", "User", "A user")),
#'   system = list(c4_system("app", "App", "An app")),
#'   relationships = list(c4_rel("user", "app", "Uses"))
#' )
#'
#' # Export to PNG
#' export_c4(diagram, "architecture", format = "png")
#'
#' # Export to SVG
#' export_c4(diagram, "architecture", format = "svg")
#' }
export_c4 <- function(diagram,
                      file,
                      format = c("png", "svg", "pdf", "html"),
                      width = NULL,
                      height = NULL,
                      dpi = 300) {
  format <- match.arg(format)

  # Add extension if not present
  if (!grepl(paste0("\\.", format, "$"), file)) {
    file <- paste0(file, ".", format)
  }

  if (format == "html") {
    # Save as HTML
    htmlwidgets::saveWidget(diagram, file, selfcontained = TRUE)
    cli::cli_alert_success("Exported diagram to {.file {file}}")
    return(invisible(file))
  }

  # For SVG, PNG, PDF we need to use DiagrammeRsvg
  if (!requireNamespace("DiagrammeRsvg", quietly = TRUE)) {
    cli::cli_abort(
      c(
        "Package {.pkg DiagrammeRsvg} is required for {format} export.",
        "i" = "Install it with: install.packages('DiagrammeRsvg')"
      )
    )
  }

  # Convert to SVG first
  svg_string <- DiagrammeRsvg::export_svg(diagram)

  if (format == "svg") {
    # Save SVG directly
    writeLines(svg_string, file)
    cli::cli_alert_success("Exported diagram to {.file {file}}")
    return(invisible(file))
  }

  # For PNG and PDF, we need rsvg
  if (!requireNamespace("rsvg", quietly = TRUE)) {
    cli::cli_abort(
      c(
        "Package {.pkg rsvg} is required for {format} export.",
        "i" = "Install it with: install.packages('rsvg')"
      )
    )
  }

  if (format == "png") {
    # Convert SVG to PNG
    rsvg::rsvg_png(
      charToRaw(svg_string),
      file = file,
      width = width,
      height = height
    )
    cli::cli_alert_success("Exported diagram to {.file {file}} ({dpi} DPI)")
  } else if (format == "pdf") {
    # Convert SVG to PDF
    rsvg::rsvg_pdf(
      charToRaw(svg_string),
      file = file,
      width = width,
      height = height
    )
    cli::cli_alert_success("Exported diagram to {.file {file}}")
  }

  invisible(file)
}

#' Export C4 diagram to multiple formats
#'
#' Convenience function to export a diagram to multiple formats at once
#'
#' @param diagram A DiagrammeR graph object
#' @param file Base filename (without extension)
#' @param formats Character vector of formats: "png", "svg", "pdf", "html"
#' @param ... Additional arguments passed to export_c4
#' @return Invisible vector of created file paths
#' @export
#' @examples
#' \dontrun{
#' diagram <- c4_context(
#'   title = "My System",
#'   person = list(c4_person("user", "User", "A user")),
#'   system = list(c4_system("app", "App", "An app")),
#'   relationships = list(c4_rel("user", "app", "Uses"))
#' )
#'
#' # Export to PNG, SVG, and PDF
#' export_c4_all(diagram, "architecture", formats = c("png", "svg", "pdf"))
#' }
export_c4_all <- function(diagram,
                          file,
                          formats = c("png", "svg", "pdf"),
                          ...) {
  # Remove extension from file if present
  file <- sub("\\.[^.]*$", "", file)

  files <- character(0)
  for (fmt in formats) {
    output_file <- export_c4(diagram, file, format = fmt, ...)
    files <- c(files, output_file)
  }

  cli::cli_alert_success("Exported {length(formats)} format{?s}")
  invisible(files)
}

#' Get DOT notation from a C4 diagram
#'
#' Extract the underlying DOT/Graphviz code from a diagram object
#'
#' @param diagram A DiagrammeR graph object
#' @return Character string with DOT notation
#' @export
#' @examples
#' \dontrun{
#' diagram <- c4_context(
#'   title = "My System",
#'   person = list(c4_person("user", "User", "A user")),
#'   system = list(c4_system("app", "App", "An app")),
#'   relationships = list(c4_rel("user", "app", "Uses"))
#' )
#'
#' dot_code <- c4_get_dot(diagram)
#' cat(dot_code)
#' }
c4_get_dot <- function(diagram) {
  if ("dgr_graph" %in% class(diagram)) {
    # DiagrammeR graph object
    return(diagram$dot_code)
  } else if ("htmlwidget" %in% class(diagram)) {
    # grViz htmlwidget
    return(diagram$x$diagram)
  } else {
    cli::cli_abort("Unknown diagram object type")
  }
}

#' Save DOT notation to file
#'
#' @param diagram A DiagrammeR graph object
#' @param file Output file path
#' @return Invisible file path
#' @export
export_c4_dot <- function(diagram, file) {
  dot_code <- c4_get_dot(diagram)

  # Add .dot extension if not present
  if (!grepl("\\.dot$", file)) {
    file <- paste0(file, ".dot")
  }

  writeLines(dot_code, file)
  cli::cli_alert_success("Exported DOT notation to {.file {file}}")
  invisible(file)
}
