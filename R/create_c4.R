#' Create a C4 System Context Diagram
#'
#' @param title Character string for diagram title
#' @param person List of person elements
#' @param system List of system elements
#' @param external_system List of external system elements
#' @param relationships List of relationships between elements
#' @param theme Character string for color theme ("default", "dark", "blue")
#' @return A DiagrammeR graph object
#' @export
#' @examples
#' \dontrun{
#' # Create a simple system context diagram
#' c4_context(
#'   title = "E-Commerce System Context",
#'   person = list(
#'     list(id = "customer", label = "Customer", description = "Shops online")
#'   ),
#'   system = list(
#'     list(
#'       id = "ecommerce", label = "E-Commerce System",
#'       description = "Allows customers to buy products online"
#'     )
#'   ),
#'   relationships = list(
#'     list(from = "customer", to = "ecommerce", label = "Uses")
#'   )
#' )
#' }
c4_context <- function(title = "System Context",
                       person = list(),
                       system = list(),
                       external_system = list(),
                       relationships = list(),
                       theme = "default") {
  # Input validation
  check_string(title)
  check_list(person)
  check_list(system)
  check_list(external_system)
  check_list(relationships)
  check_theme(theme)

  # Create nodes
  nodes <- create_c4_nodes(person, system, external_system, level = "context")

  # Create edges
  edges <- create_c4_edges(relationships)

  # Generate DOT notation
  dot_code <- generate_c4_dot(title, nodes, edges, theme, level = "context")

  # Create DiagrammeR graph
  DiagrammeR::grViz(dot_code)
}

#' Create a C4 Container Diagram
#'
#' @param title Character string for diagram title
#' @param person List of person elements
#' @param container List of container elements
#' @param external_system List of external system elements
#' @param relationships List of relationships between elements
#' @param theme Character string for color theme
#' @return A DiagrammeR graph object
#' @export
c4_container_diagram <- function(title = "Container Diagram",
                                 person = list(),
                                 container = list(),
                                 external_system = list(),
                                 relationships = list(),
                                 theme = "default") {
  # Input validation
  check_string(title)
  check_list(person)
  check_list(container)
  check_list(external_system)
  check_list(relationships)
  check_theme(theme)

  # Create nodes
  nodes <- create_c4_nodes(person, container, external_system, level = "container")

  # Create edges
  edges <- create_c4_edges(relationships)

  # Generate DOT notation
  dot_code <- generate_c4_dot(title, nodes, edges, theme, level = "container")

  # Create DiagrammeR graph
  DiagrammeR::grViz(dot_code)
}

#' Create a C4 Component Diagram
#'
#' @param title Character string for diagram title
#' @param component List of component elements
#' @param external_system List of external system elements
#' @param relationships List of relationships between elements
#' @param theme Character string for color theme
#' @return A DiagrammeR graph object
#' @export
c4_component_diagram <- function(title = "Component Diagram",
                                 component = list(),
                                 external_system = list(),
                                 relationships = list(),
                                 theme = "default") {
  # Input validation
  check_string(title)
  check_list(component)
  check_list(external_system)
  check_list(relationships)
  check_theme(theme)

  # Create nodes
  nodes <- create_c4_nodes(list(), component, external_system, level = "component")

  # Create edges
  edges <- create_c4_edges(relationships)

  # Generate DOT notation
  dot_code <- generate_c4_dot(title, nodes, edges, theme, level = "component")

  # Create DiagrammeR graph
  DiagrammeR::grViz(dot_code)
}
