# Constructor functions --------------------------------------------------

#' Create a person element for C4 diagrams
#'
#' @param id Unique identifier for the person
#' @param label Display label for the person
#' @param description Optional description of the person's role
#' @return A list representing a person element
#' @export
#' @examples
#' customer <- c4_person("customer", "Customer", "A person who buys products")
c4_person <- function(id, label = id, description = "") {
  check_string(id)
  check_string(label)
  check_string(description)

  list(
    id = id,
    label = label,
    description = description
  )
}

#' Create a system element for C4 diagrams
#'
#' @param id Unique identifier for the system
#' @param label Display label for the system
#' @param description Optional description of the system
#' @param technology Optional technology information
#' @return A list representing a system element
#' @export
#' @examples
#' api <- c4_system("api", "API Gateway", "Handles all API requests", "Node.js")
c4_system <- function(id, label = id, description = "", technology = "") {
  check_string(id)
  check_string(label)
  check_string(description)
  check_string(technology)

  list(
    id = id,
    label = label,
    description = description,
    technology = technology
  )
}

#' Create a container element for C4 diagrams
#'
#' @param id Unique identifier for the container
#' @param label Display label for the container
#' @param description Optional description of the container
#' @param technology Optional technology information
#' @return A list representing a container element
#' @export
#' @examples
#' db <- c4_container("db", "Database", "Stores user data", "PostgreSQL")
c4_container <- function(id, label = id, description = "", technology = "") {
  check_string(id)
  check_string(label)
  check_string(description)
  check_string(technology)

  list(
    id = id,
    label = label,
    description = description,
    technology = technology
  )
}

#' Create a component element for C4 diagrams
#'
#' @param id Unique identifier for the component
#' @param label Display label for the component
#' @param description Optional description of the component
#' @param technology Optional technology information
#' @return A list representing a component element
#' @export
#' @examples
#' controller <- c4_component(
#'   "controller", "User Controller",
#'   "Handles user requests", "Spring Boot"
#' )
c4_component <- function(id, label = id, description = "", technology = "") {
  check_string(id)
  check_string(label)
  check_string(description)
  check_string(technology)

  list(
    id = id,
    label = label,
    description = description,
    technology = technology
  )
}

#' Create an external system element for C4 diagrams
#'
#' @param id Unique identifier for the external system
#' @param label Display label for the external system
#' @param description Optional description of the external system
#' @return A list representing an external system element
#' @export
#' @examples
#' payment <- c4_external_system(
#'   "payment", "Payment Gateway",
#'   "Processes credit card payments"
#' )
c4_external_system <- function(id, label = id, description = "") {
  check_string(id)
  check_string(label)
  check_string(description)

  list(
    id = id,
    label = label,
    description = description
  )
}

#' Create a relationship for C4 diagrams
#'
#' @param from Source element ID
#' @param to Target element ID
#' @param label Description of the relationship
#' @param technology Optional technology used for the relationship
#' @return A list representing a relationship
#' @export
#' @examples
#' rel <- c4_rel("user", "system", "Uses", "HTTPS")
c4_rel <- function(from, to, label = "", technology = "") {
  check_string(from)
  check_string(to)
  check_string(label)
  check_string(technology)

  list(
    from = from,
    to = to,
    label = label,
    technology = technology
  )
}
