# Helper functions -------------------------------------------------------

#' Create C4 nodes
#' @param person List of person elements
#' @param system_or_container List of system/container/component elements
#' @param external_system List of external system elements
#' @param level Character string indicating diagram level
#' @return Data frame of nodes
#' @keywords internal
create_c4_nodes <- function(person, system_or_container, external_system, level) {
  # Initialize empty data frame with proper structure
  nodes <- tibble::tibble(
    id = character(0),
    label = character(0),
    type = character(0),
    description = character(0),
    technology = character(0)
  )

  # Add person nodes
  if (length(person) > 0) {
    person_nodes <- purrr::map_dfr(person, ~ {
      tibble::tibble(
        id = .x$id,
        label = .x$label %||% .x$id,
        type = "person",
        description = .x$description %||% "",
        technology = .x$technology %||% ""
      )
    })
    nodes <- dplyr::bind_rows(nodes, person_nodes)
  }

  # Add system/container/component nodes
  if (length(system_or_container) > 0) {
    node_type <- switch(level,
      "context" = "system",
      "container" = "container",
      "component" = "component"
    )

    system_nodes <- purrr::map_dfr(system_or_container, ~ {
      tibble::tibble(
        id = .x$id,
        label = .x$label %||% .x$id,
        type = node_type,
        description = .x$description %||% "",
        technology = .x$technology %||% ""
      )
    })
    nodes <- dplyr::bind_rows(nodes, system_nodes)
  }

  # Add external system nodes
  if (length(external_system) > 0) {
    external_nodes <- purrr::map_dfr(external_system, ~ {
      tibble::tibble(
        id = .x$id,
        label = .x$label %||% .x$id,
        type = "external_system",
        description = .x$description %||% "",
        technology = .x$technology %||% ""
      )
    })
    nodes <- dplyr::bind_rows(nodes, external_nodes)
  }

  nodes
}

#' Create C4 edges
#' @param relationships List of relationship elements
#' @return Data frame of edges
#' @keywords internal
create_c4_edges <- function(relationships) {
  if (length(relationships) == 0) {
    return(
      tibble::tibble(
        from = character(0),
        to = character(0),
        label = character(0),
        technology = character(0)
      )
    )
  }

  purrr::map_dfr(relationships, ~ {
    base_edge <- tibble::tibble(
      from = .x$from,
      to = .x$to,
      label = .x$label %||% "",
      technology = .x$technology %||% ""
    )

    # Add advanced relationship attributes if present
    if (!is.null(.x$type)) base_edge$type <- .x$type
    if (!is.null(.x$style)) base_edge$style <- .x$style
    if (!is.null(.x$direction)) base_edge$direction <- .x$direction

    base_edge
  })
}

#' Generate DOT notation for C4 diagram
#' @param title Character string for diagram title
#' @param nodes Data frame of nodes
#' @param edges Data frame of edges
#' @param theme Character string for theme or c4_theme object
#' @param level Character string for diagram level
#' @param groups List of group objects (optional)
#' @return Character string with DOT notation
#' @keywords internal
generate_c4_dot <- function(title, nodes, edges, theme, level, groups = list()) {
  # Get theme colors (support both string themes and custom theme objects)
  if (inherits(theme, "c4_theme")) {
    colors <- theme
  } else {
    colors <- get_c4_theme(theme)
  }

  # Build DOT string using glue for better readability
  dot_header <- glue::glue(
    'digraph {{
      graph [rankdir=TB, bgcolor="{colors$bg}", fontname="Arial"];
      node [fontname="Arial", fontsize=10];
      edge [fontname="Arial", fontsize=8];

      label="{title}";
      labelloc=t;
      fontsize=16;

    '
  )

  # Add groups (subgraphs)
  dot_groups <- ""
  if (length(groups) > 0) {
    dot_groups <- generate_group_dot(groups, colors)
  }

  # Add nodes (exclude nodes that are in groups)
  dot_nodes <- ""
  if (nrow(nodes) > 0) {
    # Get IDs of nodes in groups
    grouped_ids <- character(0)
    if (length(groups) > 0) {
      grouped_ids <- unique(unlist(purrr::map(groups, ~ .x$members)))
    }

    # Only render nodes not in groups here (grouped nodes are in subgraphs)
    ungrouped_nodes <- nodes[!nodes$id %in% grouped_ids, ]

    if (nrow(ungrouped_nodes) > 0) {
      dot_nodes <- purrr::pmap_chr(ungrouped_nodes, function(id, label, type, description, technology) {
        style <- get_node_style(type, colors)
        node_label <- create_node_label(label, description, technology)

        glue::glue('  {id} [label="{node_label}", {style}];')
      }) |>
        paste(collapse = "\n")
    }
  }

  # Add edges (support advanced relationship attributes)
  dot_edges <- ""
  if (nrow(edges) > 0) {
    # Check if we have advanced relationship attributes
    has_advanced <- any(c("type", "style", "direction") %in% names(edges))

    if (has_advanced) {
      dot_edges <- generate_advanced_edges_dot(edges, colors)
    } else {
      dot_edges <- purrr::pmap_chr(edges, function(from, to, label, technology, ...) {
        edge_label <- if (technology != "") {
          glue::glue("{label}\\n[{technology}]")
        } else {
          label
        }

        glue::glue('  {from} -> {to} [label="{edge_label}", color="{colors$edge}"];')
      }) |>
        paste(collapse = "\n")
    }
  }

  # Combine all parts
  paste(dot_header, dot_groups, dot_nodes, "", dot_edges, "}", sep = "\n")
}

#' Get C4 theme colors
#' @param theme Character string for theme name
#' @return Named list of colors
#' @keywords internal
get_c4_theme <- function(theme) {
  themes <- list(
    default = list(
      bg = "white",
      person = "#08427B",
      system = "#1168BD",
      container = "#438DD5",
      component = "#85BBF0",
      external_system = "#999999",
      edge = "#666666"
    ),
    dark = list(
      bg = "#2D2D2D",
      person = "#4A90E2",
      system = "#5BA0F2",
      container = "#7BB3F0",
      component = "#9BC7F5",
      external_system = "#CCCCCC",
      edge = "#DDDDDD"
    ),
    blue = list(
      bg = "#F0F8FF",
      person = "#003366",
      system = "#0066CC",
      container = "#3399FF",
      component = "#66B2FF",
      external_system = "#666666",
      edge = "#333333"
    )
  )

  themes[[theme]] %||% themes[["default"]]
}

#' Get node style based on type
#' @param type Character string for node type
#' @param colors Named list of theme colors
#' @return Character string with node style
#' @keywords internal
get_node_style <- function(type, colors) {
  base_style <- 'shape=box, style="filled,rounded", margin=0.1, penwidth=2'

  color <- switch(type,
    person = colors$person,
    system = colors$system,
    container = colors$container,
    component = colors$component,
    external_system = colors$external_system,
    colors$system
  )

  text_color <- if (type == "external_system") "black" else "white"

  glue::glue('{base_style}, fillcolor="{color}", fontcolor="{text_color}"')
}

#' Create formatted node label
#' @param label Character string for node label
#' @param description Character string for node description
#' @param technology Character string for technology
#' @return Character string with formatted label
#' @keywords internal
create_node_label <- function(label, description, technology) {
  # Escape special characters
  label <- escape_dot_string(label)
  description <- escape_dot_string(description)
  technology <- escape_dot_string(technology)

  # Build label components
  label_parts <- c(
    "", # Empty line at start
    label
  )

  if (description != "") {
    label_parts <- c(label_parts, "", description)
  }

  if (technology != "") {
    label_parts <- c(label_parts, glue::glue("[{technology}]"))
  }

  label_parts <- c(label_parts, "") # Empty line at end

  paste(label_parts, collapse = "\\n")
}

#' Escape special characters for DOT notation
#' @param string Character string to escape
#' @return Character string with escaped characters
#' @keywords internal
escape_dot_string <- function(string) {
  stringr::str_replace_all(string, '"', '\\\\"')
}

# Input validation functions ---------------------------------------------

#' Check if input is a single string
#' @param x Input to check
#' @param arg Argument name for error message
#' @keywords internal
check_string <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.character(x) || length(x) != 1) {
    cli::cli_abort(
      "{.arg {arg}} must be a single character string, not {.obj_type_friendly {x}}.",
      call = call
    )
  }
}

#' Check if input is a list
#' @param x Input to check
#' @param arg Argument name for error message
#' @keywords internal
check_list <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.list(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a list, not {.obj_type_friendly {x}}.",
      call = call
    )
  }
}

#' Check if theme is valid
#' @param x Input to check
#' @param arg Argument name for error message
#' @keywords internal
check_theme <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_string(x, arg, call)

  valid_themes <- c("default", "dark", "blue")
  if (!x %in% valid_themes) {
    cli::cli_abort(
      "{.arg {arg}} must be one of {.val {valid_themes}}, not {.val {x}}.",
      call = call
    )
  }
}

# Utilities --------------------------------------------------------------

#' Null-coalescing operator
#' @param a First value
#' @param b Default value if a is NULL/empty
#' @return a if not NULL/empty, otherwise b
#' @keywords internal
#' @name null-coalescing-operator
`%||%` <- function(a, b) {
  if (is.null(a) || length(a) == 0 || (is.character(a) && a == "")) b else a
}
