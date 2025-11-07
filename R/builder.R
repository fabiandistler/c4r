# Fluent builder interface -----------------------------------------------

#' Create a C4 diagram builder
#'
#' Initialize a fluent builder for creating C4 diagrams with a chainable API
#'
#' @param title Diagram title
#' @param theme Theme name or c4_theme object
#' @return A c4_builder object
#' @export
#' @examples
#' \dontrun{
#' diagram <- c4_builder() %>%
#'   set_title("E-Commerce System") %>%
#'   set_theme("blue") %>%
#'   add_person("customer", "Customer", "Buys products") %>%
#'   add_system("shop", "Shop System", "E-commerce platform", "React") %>%
#'   add_relationship("customer", "shop", "Browses", "HTTPS") %>%
#'   build_context()
#' }
c4_builder <- function(title = "System Diagram", theme = "default") {
  builder <- list(
    title = title,
    theme = theme,
    persons = list(),
    systems = list(),
    containers = list(),
    components = list(),
    external_systems = list(),
    relationships = list(),
    groups = list()
  )

  class(builder) <- c("c4_builder", "list")
  builder
}

#' Set the title for the diagram
#'
#' @param builder A c4_builder object
#' @param title Diagram title
#' @return Updated builder object
#' @export
set_title <- function(builder, title) {
  check_builder(builder)
  builder$title <- title
  builder
}

#' Set the theme for the diagram
#'
#' @param builder A c4_builder object
#' @param theme Theme name or c4_theme object
#' @return Updated builder object
#' @export
set_theme <- function(builder, theme) {
  check_builder(builder)
  builder$theme <- theme
  builder
}

#' Add a person element to the builder
#'
#' @param builder A c4_builder object
#' @param id Element identifier
#' @param label Element label
#' @param description Element description
#' @return Updated builder object
#' @export
add_person <- function(builder, id, label = id, description = "") {
  check_builder(builder)
  builder$persons <- c(builder$persons, list(c4_person(id, label, description)))
  builder
}

#' Add a system element to the builder
#'
#' @param builder A c4_builder object
#' @param id Element identifier
#' @param label Element label
#' @param description Element description
#' @param technology Technology stack
#' @return Updated builder object
#' @export
add_system <- function(builder, id, label = id, description = "", technology = "") {
  check_builder(builder)
  builder$systems <- c(builder$systems, list(c4_system(id, label, description, technology)))
  builder
}

#' Add a container element to the builder
#'
#' @param builder A c4_builder object
#' @param id Element identifier
#' @param label Element label
#' @param description Element description
#' @param technology Technology stack
#' @return Updated builder object
#' @export
add_container <- function(builder, id, label = id, description = "", technology = "") {
  check_builder(builder)
  builder$containers <- c(builder$containers, list(c4_container(id, label, description, technology)))
  builder
}

#' Add a component element to the builder
#'
#' @param builder A c4_builder object
#' @param id Element identifier
#' @param label Element label
#' @param description Element description
#' @param technology Technology stack
#' @return Updated builder object
#' @export
add_component <- function(builder, id, label = id, description = "", technology = "") {
  check_builder(builder)
  builder$components <- c(builder$components, list(c4_component(id, label, description, technology)))
  builder
}

#' Add an external system element to the builder
#'
#' @param builder A c4_builder object
#' @param id Element identifier
#' @param label Element label
#' @param description Element description
#' @return Updated builder object
#' @export
add_external_system <- function(builder, id, label = id, description = "") {
  check_builder(builder)
  builder$external_systems <- c(builder$external_systems, list(c4_external_system(id, label, description)))
  builder
}

#' Add a relationship to the builder
#'
#' @param builder A c4_builder object
#' @param from Source element ID
#' @param to Target element ID
#' @param label Relationship description
#' @param technology Technology/protocol used
#' @param type Relationship type (for advanced relationships)
#' @param style Line style (for advanced relationships)
#' @return Updated builder object
#' @export
add_relationship <- function(builder, from, to, label = "", technology = "", type = NULL, style = NULL) {
  check_builder(builder)
  rel <- c4_rel(from, to, label, technology)

  # Add advanced attributes if provided
  if (!is.null(type)) rel$type <- type
  if (!is.null(style)) rel$style <- style

  builder$relationships <- c(builder$relationships, list(rel))
  builder
}

#' Add a group/boundary to the builder
#'
#' @param builder A c4_builder object
#' @param id Group identifier
#' @param label Group label
#' @param members Element IDs in this group
#' @param style Border style
#' @return Updated builder object
#' @export
add_group <- function(builder, id, label = id, members = character(0), style = "dashed") {
  check_builder(builder)
  builder$groups <- c(builder$groups, list(c4_group(id, label, members, style)))
  builder
}

#' Build a context diagram from the builder
#'
#' @param builder A c4_builder object
#' @return A DiagrammeR graph object
#' @export
build_context <- function(builder) {
  check_builder(builder)

  c4_context(
    title = builder$title,
    person = builder$persons,
    system = builder$systems,
    external_system = builder$external_systems,
    relationships = builder$relationships,
    theme = builder$theme,
    groups = builder$groups
  )
}

#' Build a container diagram from the builder
#'
#' @param builder A c4_builder object
#' @return A DiagrammeR graph object
#' @export
build_container <- function(builder) {
  check_builder(builder)

  c4_container_diagram(
    title = builder$title,
    person = builder$persons,
    container = builder$containers,
    external_system = builder$external_systems,
    relationships = builder$relationships,
    theme = builder$theme,
    groups = builder$groups
  )
}

#' Build a component diagram from the builder
#'
#' @param builder A c4_builder object
#' @return A DiagrammeR graph object
#' @export
build_component <- function(builder) {
  check_builder(builder)

  c4_component_diagram(
    title = builder$title,
    component = builder$components,
    external_system = builder$external_systems,
    relationships = builder$relationships,
    theme = builder$theme,
    groups = builder$groups
  )
}

#' Validate builder state
#'
#' @param builder Object to check
#' @keywords internal
check_builder <- function(builder) {
  if (!inherits(builder, "c4_builder")) {
    cli::cli_abort("Expected a {.cls c4_builder} object")
  }
}

#' Print method for c4_builder
#'
#' @param x A c4_builder object
#' @param ... Additional arguments (unused)
#' @export
print.c4_builder <- function(x, ...) {
  cli::cli_h2("C4 Builder")
  cli::cli_text("Title: {.field {x$title}}")
  cli::cli_text("Theme: {.val {x$theme}}")
  cli::cli_text("")

  cli::cli_alert_info("Elements:")
  cli::cli_text("  Persons: {length(x$persons)}")
  cli::cli_text("  Systems: {length(x$systems)}")
  cli::cli_text("  Containers: {length(x$containers)}")
  cli::cli_text("  Components: {length(x$components)}")
  cli::cli_text("  External systems: {length(x$external_systems)}")
  cli::cli_text("  Groups: {length(x$groups)}")
  cli::cli_text("")
  cli::cli_alert_info("Relationships: {length(x$relationships)}")

  invisible(x)
}
