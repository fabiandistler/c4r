# Tibble input support ---------------------------------------------------

#' Create person elements from a tibble or data frame
#'
#' @param data A tibble or data frame with columns: id, label, description
#' @return A list of person elements
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' persons_df <- tribble(
#'   ~id,     ~label,    ~description,
#'   "user1", "User 1",  "First user",
#'   "user2", "User 2",  "Second user"
#' )
#' persons <- c4_persons_from_tibble(persons_df)
#' }
c4_persons_from_tibble <- function(data) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame or tibble.")
  }

  required_cols <- c("id")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "Missing required column{?s}: {.field {missing_cols}}"
    )
  }

  # Add default columns if missing
  if (!"label" %in% names(data)) data$label <- data$id
  if (!"description" %in% names(data)) data$description <- ""

  purrr::pmap(data, function(id, label, description, ...) {
    c4_person(id, label, description)
  })
}

#' Create system elements from a tibble or data frame
#'
#' @param data A tibble or data frame with columns: id, label, description, technology
#' @return A list of system elements
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' systems_df <- tribble(
#'   ~id,   ~label,      ~description,        ~technology,
#'   "api", "API",       "REST API service",  "Node.js",
#'   "db",  "Database",  "Data storage",      "PostgreSQL"
#' )
#' systems <- c4_systems_from_tibble(systems_df)
#' }
c4_systems_from_tibble <- function(data) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame or tibble.")
  }

  required_cols <- c("id")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "Missing required column{?s}: {.field {missing_cols}}"
    )
  }

  # Add default columns if missing
  if (!"label" %in% names(data)) data$label <- data$id
  if (!"description" %in% names(data)) data$description <- ""
  if (!"technology" %in% names(data)) data$technology <- ""

  purrr::pmap(data, function(id, label, description, technology, ...) {
    c4_system(id, label, description, technology)
  })
}

#' Create container elements from a tibble or data frame
#'
#' @param data A tibble or data frame with columns: id, label, description, technology
#' @return A list of container elements
#' @export
c4_containers_from_tibble <- function(data) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame or tibble.")
  }

  required_cols <- c("id")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "Missing required column{?s}: {.field {missing_cols}}"
    )
  }

  # Add default columns if missing
  if (!"label" %in% names(data)) data$label <- data$id
  if (!"description" %in% names(data)) data$description <- ""
  if (!"technology" %in% names(data)) data$technology <- ""

  purrr::pmap(data, function(id, label, description, technology, ...) {
    c4_container(id, label, description, technology)
  })
}

#' Create component elements from a tibble or data frame
#'
#' @param data A tibble or data frame with columns: id, label, description, technology
#' @return A list of component elements
#' @export
c4_components_from_tibble <- function(data) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame or tibble.")
  }

  required_cols <- c("id")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "Missing required column{?s}: {.field {missing_cols}}"
    )
  }

  # Add default columns if missing
  if (!"label" %in% names(data)) data$label <- data$id
  if (!"description" %in% names(data)) data$description <- ""
  if (!"technology" %in% names(data)) data$technology <- ""

  purrr::pmap(data, function(id, label, description, technology, ...) {
    c4_component(id, label, description, technology)
  })
}

#' Create external system elements from a tibble or data frame
#'
#' @param data A tibble or data frame with columns: id, label, description
#' @return A list of external system elements
#' @export
c4_external_systems_from_tibble <- function(data) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame or tibble.")
  }

  required_cols <- c("id")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "Missing required column{?s}: {.field {missing_cols}}"
    )
  }

  # Add default columns if missing
  if (!"label" %in% names(data)) data$label <- data$id
  if (!"description" %in% names(data)) data$description <- ""

  purrr::pmap(data, function(id, label, description, ...) {
    c4_external_system(id, label, description)
  })
}

#' Create relationship elements from a tibble or data frame
#'
#' @param data A tibble or data frame with columns: from, to, label, technology
#' @return A list of relationship elements
#' @export
#' @examples
#' \dontrun{
#' library(tibble)
#' rels_df <- tribble(
#'   ~from,  ~to,     ~label,         ~technology,
#'   "user", "app",   "Uses",         "HTTPS",
#'   "app",  "db",    "Reads from",   "SQL"
#' )
#' rels <- c4_rels_from_tibble(rels_df)
#' }
c4_rels_from_tibble <- function(data) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame or tibble.")
  }

  required_cols <- c("from", "to")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "Missing required column{?s}: {.field {missing_cols}}"
    )
  }

  # Add default columns if missing
  if (!"label" %in% names(data)) data$label <- ""
  if (!"technology" %in% names(data)) data$technology <- ""

  purrr::pmap(data, function(from, to, label, technology, ...) {
    c4_rel(from, to, label, technology)
  })
}
