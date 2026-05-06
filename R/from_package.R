# Build a C4 diagram from R package metadata -----------------------------

#' Build a C4 diagram from an R package
#'
#' Reads `DESCRIPTION` (and optionally `R/`) and produces a `c4_builder`
#' representing the package's dependencies (Imports/Depends/Suggests). At the
#' container level, each `R/*.R` source file is rendered as a container.
#'
#' @param path Path to the package root. Defaults to the current directory.
#' @param level Diagram level: `"context"` (package as a system surrounded by
#'   its dependencies) or `"container"` (each `R/*.R` file as a container).
#' @param include_suggests Include packages from `Suggests` (rendered with a
#'   dashed line). Default: `TRUE`.
#' @param title Optional diagram title; defaults to the package name.
#' @return A `c4_builder` object. Pipe into [build_context()] or
#'   [build_container()] to render.
#' @export
#' @examples
#' \dontrun{
#' # Diagram for the package in the current directory
#' c4_from_package() %>% build_context()
#'
#' # Container-level diagram with R/ files as containers
#' c4_from_package(level = "container") %>% build_container()
#' }
c4_from_package <- function(path = ".",
                            level = c("context", "container"),
                            include_suggests = TRUE,
                            title = NULL) {
  level <- match.arg(level)
  desc_path <- file.path(path, "DESCRIPTION")
  if (!file.exists(desc_path)) {
    cli::cli_abort(c(
      "No {.file DESCRIPTION} found at {.path {path}}.",
      "i" = "Run this from the root of an R package."
    ))
  }

  meta <- read_package_meta(desc_path)
  pkg_title <- title %||% paste0(meta$package, " architecture")

  builder <- c4_builder(title = pkg_title) %>%
    add_person("user", "User", glue::glue("Loads {meta$package}"))

  if (level == "context") {
    builder <- builder %>%
      add_system(
        meta$package,
        meta$package,
        meta$description %||% "",
        "R package"
      ) %>%
      add_relationship("user", meta$package, "Calls", "R API")

    builder <- add_dependencies(builder, meta, include_suggests, target = meta$package)
    return(builder)
  }

  # level == "container"
  r_dir <- file.path(path, "R")
  if (!dir.exists(r_dir)) {
    cli::cli_abort("Expected directory {.path {r_dir}} not found.")
  }
  r_files <- list.files(r_dir, pattern = "\\.[Rr]$")
  if (length(r_files) == 0) {
    cli::cli_alert_warning("No R source files in {.path {r_dir}}.")
  }

  for (f in r_files) {
    id <- file_to_id(f)
    builder <- builder %>%
      add_container(id, sub("\\.[Rr]$", "", f), glue::glue("Source file {f}"), "R")
  }

  if (length(r_files) > 0) {
    first_id <- file_to_id(r_files[[1]])
    builder <- builder %>%
      add_relationship("user", first_id, "Calls", "R API")
  }

  builder <- add_dependencies(builder, meta, include_suggests, target = if (length(r_files) > 0) file_to_id(r_files[[1]]) else NULL)
  builder
}

# Read DESCRIPTION metadata. Uses {desc} when available; falls back to the
# base parser so c4_from_package() works without optional dependencies.
read_package_meta <- function(desc_path) {
  if (requireNamespace("desc", quietly = TRUE)) {
    d <- desc::desc(file = desc_path)
    deps <- d$get_deps()
    return(list(
      package = d$get_field("Package", default = "package"),
      description = d$get_field("Description", default = ""),
      imports = deps$package[deps$type == "Imports"],
      depends = setdiff(deps$package[deps$type == "Depends"], "R"),
      suggests = deps$package[deps$type == "Suggests"]
    ))
  }

  dcf <- read.dcf(desc_path)
  parse_field <- function(name) {
    if (!name %in% colnames(dcf)) return(character(0))
    raw <- dcf[1, name]
    pkgs <- strsplit(raw, "[,\\n]+")[[1]]
    pkgs <- trimws(sub("\\(.*\\)", "", pkgs))
    pkgs <- pkgs[nzchar(pkgs)]
    setdiff(pkgs, "R")
  }

  list(
    package = if ("Package" %in% colnames(dcf)) dcf[1, "Package"] else "package",
    description = if ("Description" %in% colnames(dcf)) dcf[1, "Description"] else "",
    imports = parse_field("Imports"),
    depends = parse_field("Depends"),
    suggests = parse_field("Suggests")
  )
}

add_dependencies <- function(builder, meta, include_suggests, target) {
  hard <- unique(c(meta$imports, meta$depends))
  for (dep in hard) {
    id <- make_safe_id(dep)
    builder <- builder %>%
      add_external_system(id, dep, "R package dependency")
    if (!is.null(target)) {
      builder <- builder %>%
        add_relationship(target, id, "Imports", "R")
    }
  }

  if (include_suggests) {
    for (dep in meta$suggests) {
      id <- make_safe_id(dep)
      if (id %in% existing_ids(builder)) next
      builder <- builder %>%
        add_external_system(id, dep, "Optional dependency")
      if (!is.null(target)) {
        builder <- builder %>%
          add_relationship(target, id, "Suggests", "R", style = "dashed")
      }
    }
  }
  builder
}

existing_ids <- function(builder) {
  c(
    vapply(builder$external_systems, function(x) x$id, character(1)),
    vapply(builder$systems, function(x) x$id, character(1)),
    vapply(builder$containers, function(x) x$id, character(1)),
    vapply(builder$persons, function(x) x$id, character(1))
  )
}

file_to_id <- function(f) make_safe_id(sub("\\.[Rr]$", "", f))

# IDs in C4 must be valid identifiers; replace anything non-alphanumeric.
make_safe_id <- function(x) {
  out <- gsub("[^A-Za-z0-9]+", "_", x)
  out <- sub("^_+", "", out)
  out <- sub("_+$", "", out)
  if (!nzchar(out)) out <- "x"
  if (grepl("^[0-9]", out)) out <- paste0("x_", out)
  out
}
