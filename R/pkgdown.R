# pkgdown integration helpers ---------------------------------------------

#' Render a C4 diagram tuned for pkgdown sites
#'
#' Wraps a diagram object (or htmlwidget) so that it fills the available
#' Bootstrap 5 column width and respects a fixed pixel height. Diagrams
#' returned by [c4_context()] and friends already render inline in
#' Rmarkdown/Quarto, but their default width is unbounded and looks awkward
#' on a pkgdown page; this helper sets sensible defaults.
#'
#' @param diagram A DiagrammeR htmlwidget (output of [c4_context()] etc.).
#' @param height CSS height for the diagram container (e.g. `"500px"`).
#' @param width CSS width for the diagram container (default `"100%"`).
#' @return The diagram with width/height set, ready for printing.
#' @export
#' @examples
#' \dontrun{
#' diagram <- c4_from_template("three_tier")
#' pkgdown_diagram(diagram, height = "600px")
#' }
pkgdown_diagram <- function(diagram, height = "500px", width = "100%") {
  if (!inherits(diagram, "htmlwidget")) {
    cli::cli_abort("{.arg diagram} must be an htmlwidget (output of {.fn c4_context} etc.).")
  }
  diagram$width <- width
  diagram$height <- height
  if (is.null(diagram$sizingPolicy)) {
    diagram$sizingPolicy <- list()
  }
  diagram$sizingPolicy$defaultWidth <- width
  diagram$sizingPolicy$defaultHeight <- height
  diagram
}
