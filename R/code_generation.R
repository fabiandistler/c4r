# Code generation functions ----------------------------------------------

#' Generate R code from diagram elements
#'
#' Convert diagram elements back to R code for sharing or documentation
#'
#' @param elements Named list of elements (person, system, container, etc.)
#' @param relationships List of relationships
#' @param title Diagram title
#' @param theme Theme name
#' @param diagram_type Type of diagram: "context", "container", "component"
#' @return Character string with R code
#' @export
#' @examples
#' \dontrun{
#' elements <- list(
#'   person = list(c4_person("user", "User", "A user")),
#'   system = list(c4_system("app", "App", "An app"))
#' )
#' rels <- list(c4_rel("user", "app", "Uses"))
#'
#' code <- diagram_to_code(elements, rels, "My System", "default", "context")
#' cat(code)
#' }
diagram_to_code <- function(elements, relationships, title = "System Diagram", theme = "default", diagram_type = "context") {
  lines <- character(0)

  # Header
  lines <- c(lines, "library(c4r)", "", "# Define elements")

  # Generate person elements
  if (!is.null(elements$person) && length(elements$person) > 0) {
    lines <- c(lines, "# Persons")
    for (p in elements$person) {
      lines <- c(lines, generate_person_code(p))
    }
    lines <- c(lines, "")
  }

  # Generate system elements
  if (!is.null(elements$system) && length(elements$system) > 0) {
    lines <- c(lines, "# Systems")
    for (s in elements$system) {
      lines <- c(lines, generate_system_code(s))
    }
    lines <- c(lines, "")
  }

  # Generate container elements
  if (!is.null(elements$container) && length(elements$container) > 0) {
    lines <- c(lines, "# Containers")
    for (c in elements$container) {
      lines <- c(lines, generate_container_code(c))
    }
    lines <- c(lines, "")
  }

  # Generate component elements
  if (!is.null(elements$component) && length(elements$component) > 0) {
    lines <- c(lines, "# Components")
    for (comp in elements$component) {
      lines <- c(lines, generate_component_code(comp))
    }
    lines <- c(lines, "")
  }

  # Generate external system elements
  if (!is.null(elements$external_system) && length(elements$external_system) > 0) {
    lines <- c(lines, "# External Systems")
    for (e in elements$external_system) {
      lines <- c(lines, generate_external_code(e))
    }
    lines <- c(lines, "")
  }

  # Generate relationships
  if (length(relationships) > 0) {
    lines <- c(lines, "# Relationships")
    for (r in relationships) {
      lines <- c(lines, generate_rel_code(r))
    }
    lines <- c(lines, "")
  }

  # Generate diagram creation
  lines <- c(lines, "# Create diagram")
  lines <- c(lines, generate_diagram_code(elements, relationships, title, theme, diagram_type))

  paste(lines, collapse = "\n")
}

#' Generate code for a person element
#' @keywords internal
generate_person_code <- function(person) {
  glue::glue('{person$id} <- c4_person("{person$id}", "{person$label}", "{person$description}")')
}

#' Generate code for a system element
#' @keywords internal
generate_system_code <- function(system) {
  glue::glue('{system$id} <- c4_system("{system$id}", "{system$label}", "{system$description}", "{system$technology %||% ""}")')
}

#' Generate code for a container element
#' @keywords internal
generate_container_code <- function(container) {
  glue::glue('{container$id} <- c4_container("{container$id}", "{container$label}", "{container$description}", "{container$technology %||% ""}")')
}

#' Generate code for a component element
#' @keywords internal
generate_component_code <- function(component) {
  glue::glue('{component$id} <- c4_component("{component$id}", "{component$label}", "{component$description}", "{component$technology %||% ""}")')
}

#' Generate code for an external system
#' @keywords internal
generate_external_code <- function(external) {
  glue::glue('{external$id} <- c4_external_system("{external$id}", "{external$label}", "{external$description}")')
}

#' Generate code for a relationship
#' @keywords internal
generate_rel_code <- function(rel) {
  id <- make.names(paste0("rel_", rel$from, "_", rel$to))
  glue::glue('{id} <- c4_rel("{rel$from}", "{rel$to}", "{rel$label %||% ""}", "{rel$technology %||% ""}")')
}

#' Generate diagram creation code
#' @keywords internal
generate_diagram_code <- function(elements, relationships, title, theme, diagram_type) {
  lines <- character(0)

  # Build element lists
  elem_lists <- character(0)

  if (!is.null(elements$person) && length(elements$person) > 0) {
    person_ids <- purrr::map_chr(elements$person, ~ .x$id)
    elem_lists <- c(elem_lists, glue::glue('  person = list({paste(person_ids, collapse = ", ")})'))
  }

  if (!is.null(elements$system) && length(elements$system) > 0) {
    system_ids <- purrr::map_chr(elements$system, ~ .x$id)
    elem_lists <- c(elem_lists, glue::glue('  system = list({paste(system_ids, collapse = ", ")})'))
  }

  if (!is.null(elements$container) && length(elements$container) > 0) {
    container_ids <- purrr::map_chr(elements$container, ~ .x$id)
    elem_lists <- c(elem_lists, glue::glue('  container = list({paste(container_ids, collapse = ", ")})'))
  }

  if (!is.null(elements$component) && length(elements$component) > 0) {
    component_ids <- purrr::map_chr(elements$component, ~ .x$id)
    elem_lists <- c(elem_lists, glue::glue('  component = list({paste(component_ids, collapse = ", ")})'))
  }

  if (!is.null(elements$external_system) && length(elements$external_system) > 0) {
    external_ids <- purrr::map_chr(elements$external_system, ~ .x$id)
    elem_lists <- c(elem_lists, glue::glue('  external_system = list({paste(external_ids, collapse = ", ")})'))
  }

  # Build relationship list
  if (length(relationships) > 0) {
    rel_ids <- purrr::map_chr(relationships, ~ make.names(paste0("rel_", .x$from, "_", .x$to)))
    elem_lists <- c(elem_lists, glue::glue('  relationships = list({paste(rel_ids, collapse = ", ")})'))
  }

  # Build diagram call
  func_name <- switch(diagram_type,
    "context" = "c4_context",
    "container" = "c4_container_diagram",
    "component" = "c4_component_diagram",
    "c4_context"
  )

  c(
    glue::glue('diagram <- {func_name}('),
    glue::glue('  title = "{title}",'),
    paste(elem_lists, collapse = ",\n"),
    glue::glue(',\n  theme = "{theme}"'),
    ")"
  )
}

#' Save generated code to file
#'
#' @param code Character string with R code
#' @param file Output file path
#' @return Invisible file path
#' @export
save_code <- function(code, file) {
  # Add .R extension if not present
  if (!grepl("\\.R$", file, ignore.case = TRUE)) {
    file <- paste0(file, ".R")
  }

  writeLines(code, file)
  cli::cli_alert_success("Saved R code to {.file {file}}")
  invisible(file)
}

#' Export diagram elements to YAML
#'
#' @param elements Named list of elements
#' @param relationships List of relationships
#' @param file Output file path
#' @return Invisible file path
#' @export
diagram_to_yaml <- function(elements, relationships, file) {
  if (!requireNamespace("yaml", quietly = TRUE)) {
    cli::cli_abort(
      c(
        "Package {.pkg yaml} is required for YAML export.",
        "i" = "Install it with: install.packages('yaml')"
      )
    )
  }

  # Build YAML structure
  yaml_data <- list(
    elements = elements,
    relationships = relationships
  )

  # Add .yaml extension if not present
  if (!grepl("\\.ya?ml$", file)) {
    file <- paste0(file, ".yaml")
  }

  yaml::write_yaml(yaml_data, file)
  cli::cli_alert_success("Exported diagram to {.file {file}}")
  invisible(file)
}

#' Import diagram elements from YAML
#'
#' @param file Input YAML file path
#' @return List with elements and relationships
#' @export
diagram_from_yaml <- function(file) {
  if (!requireNamespace("yaml", quietly = TRUE)) {
    cli::cli_abort(
      c(
        "Package {.pkg yaml} is required for YAML import.",
        "i" = "Install it with: install.packages('yaml')"
      )
    )
  }

  if (!file.exists(file)) {
    cli::cli_abort("File not found: {.file {file}}")
  }

  data <- yaml::read_yaml(file)
  cli::cli_alert_success("Imported diagram from {.file {file}}")
  data
}
