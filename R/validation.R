# Validation and debugging tools -----------------------------------------

#' Validate a C4 diagram for common issues
#'
#' Checks for orphaned nodes, missing elements in relationships, duplicate IDs, etc.
#'
#' @param diagram A C4 diagram object (context, container, or component)
#' @param elements Named list with person, system/container/component, external_system
#' @param relationships List of relationship elements
#' @return Invisible TRUE if valid, otherwise prints issues and returns FALSE
#' @export
#' @examples
#' \dontrun{
#' result <- validate_c4(
#'   elements = list(
#'     person = list(c4_person("user", "User", "A user")),
#'     system = list(c4_system("app", "App", "An app"))
#'   ),
#'   relationships = list(c4_rel("user", "app", "Uses"))
#' )
#' }
validate_c4 <- function(elements, relationships) {
  issues <- list()
  warnings <- list()
  successes <- list()

  # Extract all element IDs
  all_ids <- character(0)
  element_types <- names(elements)

  for (elem_type in element_types) {
    if (length(elements[[elem_type]]) > 0) {
      ids <- purrr::map_chr(elements[[elem_type]], ~ .x$id)
      all_ids <- c(all_ids, ids)
    }
  }

  # Check for duplicate IDs
  dup_ids <- all_ids[duplicated(all_ids)]
  if (length(dup_ids) > 0) {
    issues <- c(issues, glue::glue("Duplicate element IDs found: {paste(unique(dup_ids), collapse = ', ')}"))
  } else {
    successes <- c(successes, "No duplicate IDs found")
  }

  # Check relationships reference existing elements
  if (length(relationships) > 0) {
    for (i in seq_along(relationships)) {
      rel <- relationships[[i]]
      if (!rel$from %in% all_ids) {
        issues <- c(issues, glue::glue("Relationship {i}: 'from' element '{rel$from}' does not exist"))
      }
      if (!rel$to %in% all_ids) {
        issues <- c(issues, glue::glue("Relationship {i}: 'to' element '{rel$to}' does not exist"))
      }
    }
    if (length(issues) == 1) { # Only the duplicate check could have added
      successes <- c(successes, "All relationships reference existing elements")
    }
  }

  # Check for orphaned nodes (no relationships)
  if (length(relationships) > 0 && length(all_ids) > 0) {
    rel_ids <- unique(c(
      purrr::map_chr(relationships, ~ .x$from),
      purrr::map_chr(relationships, ~ .x$to)
    ))
    orphaned <- setdiff(all_ids, rel_ids)
    if (length(orphaned) > 0) {
      warnings <- c(warnings, glue::glue("{length(orphaned)} orphaned element{?s} (no relationships): {paste(orphaned, collapse = ', ')}"))
    } else {
      successes <- c(successes, "No orphaned elements")
    }
  }

  # Print results
  if (length(issues) > 0) {
    cli::cli_h2("Validation Issues")
    for (issue in issues) {
      cli::cli_alert_danger(issue)
    }
  }

  if (length(warnings) > 0) {
    cli::cli_h2("Warnings")
    for (warning in warnings) {
      cli::cli_alert_warning(warning)
    }
  }

  if (length(successes) > 0 && length(issues) == 0) {
    cli::cli_h2("Validation Successful")
    for (success in successes) {
      cli::cli_alert_success(success)
    }
  }

  # Summary
  cli::cli_alert_info(glue::glue(
    "Summary: {length(all_ids)} element{?s}, {length(relationships)} relationship{?s}"
  ))

  invisible(length(issues) == 0)
}

#' Check C4 elements for common issues
#'
#' Quick validation of elements before creating a diagram
#'
#' @param ... Named arguments for different element types (person, system, container, component, external_system, relationships)
#' @return Invisible TRUE if valid, otherwise prints issues
#' @export
#' @examples
#' \dontrun{
#' check_c4_elements(
#'   person = list(c4_person("user", "User", "A user")),
#'   system = list(c4_system("app", "App", "An app")),
#'   relationships = list(c4_rel("user", "app", "Uses"))
#' )
#' }
check_c4_elements <- function(...) {
  args <- list(...)

  # Separate relationships from elements
  relationships <- args$relationships %||% list()
  elements <- args[names(args) != "relationships"]

  validate_c4(elements, relationships)
}

#' Get summary statistics for C4 diagram elements
#'
#' @param elements Named list of elements
#' @param relationships List of relationships
#' @return A list with summary statistics
#' @export
c4_summary <- function(elements, relationships = list()) {
  stats <- list()

  for (elem_type in names(elements)) {
    stats[[elem_type]] <- length(elements[[elem_type]])
  }

  stats$relationships <- length(relationships)
  stats$total_elements <- sum(unlist(stats[names(stats) != "relationships"]))

  # Calculate relationship density (avg relationships per element)
  if (stats$total_elements > 0) {
    stats$relationship_density <- round(stats$relationships / stats$total_elements, 2)
  } else {
    stats$relationship_density <- 0
  }

  class(stats) <- c("c4_summary", "list")
  stats
}

#' Print method for c4_summary
#' @param x A c4_summary object
#' @param ... Additional arguments (unused)
#' @export
print.c4_summary <- function(x, ...) {
  cli::cli_h2("C4 Diagram Summary")

  # Elements
  elem_types <- setdiff(names(x), c("relationships", "total_elements", "relationship_density"))
  if (length(elem_types) > 0) {
    cli::cli_alert_info("Elements:")
    for (type in elem_types) {
      cli::cli_text("  {.field {type}}: {x[[type]]}")
    }
    cli::cli_text("  {.field Total}: {x$total_elements}")
  }

  # Relationships
  cli::cli_alert_info("Relationships: {x$relationships}")
  cli::cli_alert_info("Relationship density: {x$relationship_density}")

  invisible(x)
}

#' Find unused elements (elements with no relationships)
#'
#' @param elements Named list of elements
#' @param relationships List of relationships
#' @return Character vector of unused element IDs
#' @export
c4_find_orphaned <- function(elements, relationships) {
  # Extract all element IDs
  all_ids <- character(0)
  for (elem_type in names(elements)) {
    if (length(elements[[elem_type]]) > 0) {
      ids <- purrr::map_chr(elements[[elem_type]], ~ .x$id)
      all_ids <- c(all_ids, ids)
    }
  }

  if (length(relationships) == 0) {
    return(all_ids)
  }

  # Get all IDs used in relationships
  rel_ids <- unique(c(
    purrr::map_chr(relationships, ~ .x$from),
    purrr::map_chr(relationships, ~ .x$to)
  ))

  setdiff(all_ids, rel_ids)
}

#' Find relationships referencing non-existent elements
#'
#' @param elements Named list of elements
#' @param relationships List of relationships
#' @return Data frame with invalid relationships
#' @export
c4_find_invalid_rels <- function(elements, relationships) {
  # Extract all element IDs
  all_ids <- character(0)
  for (elem_type in names(elements)) {
    if (length(elements[[elem_type]]) > 0) {
      ids <- purrr::map_chr(elements[[elem_type]], ~ .x$id)
      all_ids <- c(all_ids, ids)
    }
  }

  if (length(relationships) == 0) {
    return(tibble::tibble(
      index = integer(0),
      from = character(0),
      to = character(0),
      issue = character(0)
    ))
  }

  invalid <- tibble::tibble(
    index = integer(0),
    from = character(0),
    to = character(0),
    issue = character(0)
  )

  for (i in seq_along(relationships)) {
    rel <- relationships[[i]]
    issues <- character(0)

    if (!rel$from %in% all_ids) {
      issues <- c(issues, glue::glue("'from' element '{rel$from}' does not exist"))
    }
    if (!rel$to %in% all_ids) {
      issues <- c(issues, glue::glue("'to' element '{rel$to}' does not exist"))
    }

    if (length(issues) > 0) {
      invalid <- dplyr::bind_rows(
        invalid,
        tibble::tibble(
          index = i,
          from = rel$from,
          to = rel$to,
          issue = paste(issues, collapse = "; ")
        )
      )
    }
  }

  invalid
}
