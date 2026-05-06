# Scaffolding helpers for integrating c4r into other R packages -----------

#' Scaffold c4r usage in an R package
#'
#' Adds an architecture diagram skeleton to the current package: a vignette,
#' a pkgdown article entry, and (optionally) a chunk in `README.Rmd`.
#'
#' This mirrors the `usethis::use_*` family. It expects to be run from the
#' root of an R package (where `DESCRIPTION` lives), or you can pass `path`.
#'
#' @param path Path to the package root. Defaults to the current directory.
#' @param vignette Add a starter vignette `vignettes/architecture.Rmd`.
#' @param pkgdown Add an "Architecture" entry to `_pkgdown.yml`.
#' @param readme Add a c4r chunk to `README.Rmd`.
#' @param template Starter template name (see [c4_list_templates()]).
#' @param overwrite Overwrite existing scaffolding files.
#' @return Invisibly returns the character vector of created/modified files.
#' @export
#' @examples
#' \dontrun{
#' # In an R package directory:
#' use_c4r()
#' use_c4r(readme = TRUE)
#' }
use_c4r <- function(path = ".",
                    vignette = TRUE,
                    pkgdown = TRUE,
                    readme = FALSE,
                    template = "three_tier",
                    overwrite = FALSE) {
  check_pkg_root(path)
  add_c4r_to_suggests(path)

  touched <- character(0)

  if (vignette) {
    touched <- c(touched, use_c4r_vignette(path = path, template = template, overwrite = overwrite))
  }
  if (pkgdown) {
    touched <- c(touched, use_c4r_pkgdown(path = path))
  }
  if (readme) {
    touched <- c(touched, use_c4r_readme(path = path, overwrite = overwrite))
  }

  cli::cli_alert_success("c4r scaffolding complete.")
  cli::cli_text("Next: edit the generated files and run {.code devtools::build_vignettes()}.")
  invisible(touched)
}

#' Add a c4r-powered vignette to a package
#'
#' Creates `vignettes/architecture.Rmd` from a starter template and registers
#' c4r as a `Suggests` dependency.
#'
#' @inheritParams use_c4r
#' @return Invisibly returns the path to the created vignette.
#' @export
use_c4r_vignette <- function(path = ".",
                             template = "three_tier",
                             overwrite = FALSE) {
  check_pkg_root(path)

  vignettes_dir <- file.path(path, "vignettes")
  if (!dir.exists(vignettes_dir)) {
    dir.create(vignettes_dir, recursive = TRUE)
  }

  target <- file.path(vignettes_dir, "architecture.Rmd")
  if (file.exists(target) && !overwrite) {
    cli::cli_alert_info("Vignette {.file {target}} already exists. Use {.code overwrite = TRUE} to replace.")
    return(invisible(target))
  }

  src <- system.file("templates", "architecture.Rmd", package = "c4r")
  if (!nzchar(src)) {
    cli::cli_abort("Could not find bundled template {.file architecture.Rmd}.")
  }

  contents <- readLines(src)
  contents <- gsub("@TEMPLATE@", template, contents, fixed = TRUE)
  writeLines(contents, target)

  cli::cli_alert_success("Wrote {.file {target}}.")
  invisible(target)
}

#' Add a c4r article entry to `_pkgdown.yml`
#'
#' Idempotently appends an "Architecture" entry under `articles:` so that the
#' vignette appears on the pkgdown site.
#'
#' @inheritParams use_c4r
#' @return Invisibly returns the path to `_pkgdown.yml`.
#' @export
use_c4r_pkgdown <- function(path = ".") {
  check_pkg_root(path)
  require_pkg("yaml")

  yml_path <- file.path(path, "_pkgdown.yml")
  if (!file.exists(yml_path)) {
    cli::cli_alert_info("No {.file _pkgdown.yml} found. Run {.code usethis::use_pkgdown()} first.")
    return(invisible(yml_path))
  }

  yml <- yaml::read_yaml(yml_path)
  articles <- yml$articles %||% list()

  has_arch <- any(vapply(articles, function(a) {
    isTRUE(a$title == "Architecture") ||
      "architecture" %in% (a$contents %||% character(0))
  }, logical(1)))

  if (has_arch) {
    cli::cli_alert_info("{.file _pkgdown.yml} already contains an Architecture entry.")
    return(invisible(yml_path))
  }

  articles <- c(articles, list(list(
    title = "Architecture",
    navbar = "Architecture",
    contents = list("architecture")
  )))
  yml$articles <- articles

  yaml::write_yaml(yml, yml_path)

  # pkgdown's extra.css gets picked up automatically when present
  copy_pkgdown_extra_css(path)

  cli::cli_alert_success("Updated {.file {yml_path}} with an Architecture article.")
  invisible(yml_path)
}

#' Add a c4r chunk to `README.Rmd`
#'
#' Appends a code chunk to the README that renders an architecture diagram.
#' If `README.Rmd` does not exist, it is created with a minimal header.
#'
#' @inheritParams use_c4r
#' @return Invisibly returns the path to `README.Rmd`.
#' @export
use_c4r_readme <- function(path = ".", overwrite = FALSE) {
  check_pkg_root(path)

  src <- system.file("templates", "readme-chunk.Rmd", package = "c4r")
  if (!nzchar(src)) {
    cli::cli_abort("Could not find bundled template {.file readme-chunk.Rmd}.")
  }
  snippet <- paste(readLines(src), collapse = "\n")

  target <- file.path(path, "README.Rmd")
  if (!file.exists(target)) {
    writeLines(c(
      "---",
      "output: github_document",
      "---",
      "",
      "<!-- README.Rmd generates README.md. Please edit README.Rmd. -->",
      "",
      snippet
    ), target)
    cli::cli_alert_success("Created {.file {target}} with a c4r chunk.")
    return(invisible(target))
  }

  current <- paste(readLines(target), collapse = "\n")
  if (grepl("c4r::", current, fixed = TRUE) && !overwrite) {
    cli::cli_alert_info("{.file {target}} already references c4r. Use {.code overwrite = TRUE} to append again.")
    return(invisible(target))
  }

  writeLines(c(current, "", snippet), target)
  cli::cli_alert_success("Appended c4r chunk to {.file {target}}.")
  invisible(target)
}

#' Add a GitHub Actions workflow that renders c4r diagrams
#'
#' Copies a reusable workflow to `.github/workflows/c4r-render.yaml`. The
#' workflow runs on every push, renders an SVG from
#' `inst/architecture/diagram.R`, and uploads it as a build artifact.
#'
#' @inheritParams use_c4r
#' @return Invisibly returns the path to the workflow file.
#' @export
use_c4r_action <- function(path = ".", overwrite = FALSE) {
  check_pkg_root(path)

  src <- system.file("templates", "c4r-render.yaml", package = "c4r")
  if (!nzchar(src)) {
    cli::cli_abort("Could not find bundled template {.file c4r-render.yaml}.")
  }

  workflows_dir <- file.path(path, ".github", "workflows")
  if (!dir.exists(workflows_dir)) {
    dir.create(workflows_dir, recursive = TRUE)
  }

  target <- file.path(workflows_dir, "c4r-render.yaml")
  if (file.exists(target) && !overwrite) {
    cli::cli_alert_info("Workflow {.file {target}} already exists. Use {.code overwrite = TRUE} to replace.")
    return(invisible(target))
  }

  file.copy(src, target, overwrite = TRUE)
  cli::cli_alert_success("Wrote {.file {target}}.")
  invisible(target)
}

# Internal helpers --------------------------------------------------------

check_pkg_root <- function(path) {
  desc_path <- file.path(path, "DESCRIPTION")
  if (!file.exists(desc_path)) {
    cli::cli_abort(c(
      "No {.file DESCRIPTION} found at {.path {path}}.",
      "i" = "Run this from the root of an R package."
    ))
  }
  invisible(TRUE)
}

require_pkg <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cli::cli_abort(c(
      "Package {.pkg {pkg}} is required for this operation.",
      "i" = "Install it with {.code install.packages(\"{pkg}\")}."
    ))
  }
}

add_c4r_to_suggests <- function(path) {
  if (requireNamespace("desc", quietly = TRUE)) {
    d <- desc::desc(file = file.path(path, "DESCRIPTION"))
    deps <- d$get_deps()
    if (!"c4r" %in% deps$package) {
      d$set_dep("c4r", type = "Suggests")
      d$write()
      cli::cli_alert_success("Added {.pkg c4r} to Suggests in DESCRIPTION.")
    }
  } else {
    cli::cli_alert_info("Install {.pkg desc} to auto-update DESCRIPTION; skipping.")
  }
}

copy_pkgdown_extra_css <- function(path) {
  src <- system.file("pkgdown", "extra.css", package = "c4r")
  if (!nzchar(src)) {
    return(invisible(NULL))
  }
  dest_dir <- file.path(path, "pkgdown")
  if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)
  dest <- file.path(dest_dir, "extra.css")
  if (!file.exists(dest)) {
    file.copy(src, dest)
    cli::cli_alert_success("Copied pkgdown CSS to {.file {dest}}.")
  }
  invisible(dest)
}
