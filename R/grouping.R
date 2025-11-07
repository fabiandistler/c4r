# Visual grouping and boundaries -----------------------------------------

#' Create a visual group/boundary for C4 diagrams
#'
#' Groups allow you to visually cluster related elements within a boundary
#'
#' @param id Unique identifier for the group
#' @param label Display label for the group
#' @param members Character vector of element IDs to include in this group
#' @param style Border style: "solid", "dashed", "dotted", "bold"
#' @param color Border color (optional, uses theme default if not specified)
#' @param bg Background color for the group (optional, transparent if not specified)
#' @return A list representing a group element
#' @export
#' @examples
#' # Create a group for AWS cloud services
#' aws_group <- c4_group(
#'   "aws",
#'   "AWS Cloud",
#'   members = c("api", "db", "cache"),
#'   style = "dashed"
#' )
c4_group <- function(id,
                     label = id,
                     members = character(0),
                     style = c("solid", "dashed", "dotted", "bold"),
                     color = NULL,
                     bg = NULL) {
  check_string(id)
  check_string(label)

  if (!is.character(members)) {
    cli::cli_abort("{.arg members} must be a character vector of element IDs")
  }

  style <- match.arg(style)

  list(
    id = id,
    label = label,
    members = members,
    style = style,
    color = color,
    bg = bg
  )
}

#' Generate DOT notation for groups (internal helper)
#'
#' @param groups List of group objects
#' @param theme_colors Theme color list
#' @return Character string with DOT subgraph notation
#' @keywords internal
generate_group_dot <- function(groups, theme_colors) {
  if (length(groups) == 0) {
    return("")
  }

  group_strings <- character(0)

  for (i in seq_along(groups)) {
    group <- groups[[i]]

    # Determine style attributes
    style_attr <- switch(group$style,
      "solid" = "solid",
      "dashed" = "dashed",
      "dotted" = "dotted",
      "bold" = "bold"
    )

    # Determine colors
    border_color <- group$color %||% theme_colors$group_border %||% "#CCCCCC"
    bg_color <- if (!is.null(group$bg)) {
      glue::glue('bgcolor="{group$bg}"')
    } else {
      ""
    }

    # Build subgraph
    member_ids <- paste(group$members, collapse = "; ")

    group_dot <- glue::glue(
      '
  subgraph cluster_{group$id} {{
    label="{escape_dot_string(group$label)}";
    style="{style_attr}";
    color="{border_color}";
    {bg_color}
    fontsize=14;
    fontname="Arial";

    {member_ids};
  }}
      '
    )

    group_strings <- c(group_strings, group_dot)
  }

  paste(group_strings, collapse = "\n")
}

#' Create a deployment boundary group
#'
#' Convenience function for creating deployment/infrastructure boundaries
#'
#' @param id Group identifier
#' @param label Group label (e.g., "AWS Cloud", "On-Premise")
#' @param members Element IDs within this deployment boundary
#' @return A group object
#' @export
#' @examples
#' cloud <- c4_deployment_boundary(
#'   "cloud",
#'   "Cloud Infrastructure",
#'   members = c("api", "db", "queue")
#' )
c4_deployment_boundary <- function(id, label, members) {
  c4_group(
    id = id,
    label = label,
    members = members,
    style = "dashed"
  )
}

#' Create a system boundary group
#'
#' Convenience function for grouping components within a system
#'
#' @param id Group identifier
#' @param label Group label
#' @param members Element IDs within this system boundary
#' @return A group object
#' @export
c4_system_boundary <- function(id, label, members) {
  c4_group(
    id = id,
    label = label,
    members = members,
    style = "solid"
  )
}
