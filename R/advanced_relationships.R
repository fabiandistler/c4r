# Advanced relationship types --------------------------------------------

#' Create an advanced relationship with additional visual properties
#'
#' @param from Source element ID
#' @param to Target element ID
#' @param label Description of the relationship
#' @param technology Optional technology used
#' @param type Relationship type: "sync", "async", "request-response"
#' @param style Line style: "solid", "dashed", "dotted"
#' @param direction Arrow direction: "forward", "back", "both", "none"
#' @return A list representing an advanced relationship
#' @export
#' @examples
#' # Synchronous HTTP request
#' rel1 <- c4_rel_advanced("user", "api", "Makes request", "HTTPS",
#'                         type = "sync", style = "solid")
#'
#' # Asynchronous message
#' rel2 <- c4_rel_advanced("api", "queue", "Publishes event", "RabbitMQ",
#'                         type = "async", style = "dashed")
c4_rel_advanced <- function(from,
                            to,
                            label = "",
                            technology = "",
                            type = c("sync", "async", "request-response"),
                            style = c("solid", "dashed", "dotted"),
                            direction = c("forward", "back", "both", "none")) {
  check_string(from)
  check_string(to)
  check_string(label)
  check_string(technology)

  type <- match.arg(type)
  style <- match.arg(style)
  direction <- match.arg(direction)

  list(
    from = from,
    to = to,
    label = label,
    technology = technology,
    type = type,
    style = style,
    direction = direction
  )
}

#' Create a bidirectional relationship
#'
#' Convenience function for relationships that flow both ways
#'
#' @param from First element ID
#' @param to Second element ID
#' @param label Relationship description
#' @param technology Technology/protocol
#' @return An advanced relationship with bidirectional arrows
#' @export
c4_rel_bidirectional <- function(from, to, label = "", technology = "") {
  c4_rel_advanced(from, to, label, technology, direction = "both")
}

#' Create an asynchronous relationship
#'
#' Convenience function for async/event-driven relationships
#'
#' @param from Source element ID
#' @param to Target element ID
#' @param label Event/message description
#' @param technology Messaging technology
#' @return An advanced relationship styled for async communication
#' @export
c4_rel_async <- function(from, to, label = "", technology = "") {
  c4_rel_advanced(from, to, label, technology, type = "async", style = "dashed")
}

#' Generate DOT notation for advanced relationships (internal helper)
#'
#' @param edges Data frame of edges with potential advanced attributes
#' @param theme_colors Theme colors
#' @return Character string with DOT edge notation
#' @keywords internal
generate_advanced_edges_dot <- function(edges, theme_colors) {
  if (nrow(edges) == 0) {
    return("")
  }

  dot_edges <- purrr::pmap_chr(edges, function(from, to, label, technology, type = NULL, style = NULL, direction = NULL, ...) {
    # Build edge label
    edge_label <- if (technology != "") {
      glue::glue("{label}\\n[{technology}]")
    } else {
      label
    }

    # Determine line style
    line_style <- if (!is.null(style)) {
      style
    } else {
      "solid"
    }

    # Determine arrow direction
    arrow_dir <- if (!is.null(direction)) {
      switch(direction,
        "forward" = "dir=forward",
        "back" = "dir=back",
        "both" = "dir=both",
        "none" = "dir=none",
        "dir=forward"
      )
    } else {
      "dir=forward"
    }

    # Add type-specific visual hints
    type_attrs <- if (!is.null(type)) {
      switch(type,
        "async" = 'style="dashed"',
        "sync" = 'style="solid"',
        "request-response" = 'style="solid"',
        'style="solid"'
      )
    } else {
      glue::glue('style="{line_style}"')
    }

    glue::glue('  {from} -> {to} [label="{edge_label}", color="{theme_colors$edge}", {arrow_dir}, {type_attrs}];')
  })

  paste(dot_edges, collapse = "\n")
}
