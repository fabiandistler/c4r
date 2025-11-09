# Theme customization functions ------------------------------------------

#' Create a custom C4 theme
#'
#' Define custom colors for C4 diagram elements
#'
#' @param name Theme name
#' @param bg Background color
#' @param person Person node color
#' @param system System node color
#' @param container Container node color
#' @param component Component node color
#' @param external_system External system node color
#' @param edge Edge/relationship color
#' @param group_border Group boundary color (optional)
#' @return A list representing a custom theme
#' @export
#' @examples
#' # Create a corporate theme
#' corp_theme <- c4_theme(
#'   name = "corporate",
#'   bg = "#FFFFFF",
#'   person = "#E74C3C",
#'   system = "#3498DB",
#'   container = "#2ECC71",
#'   component = "#F39C12",
#'   external_system = "#95A5A6",
#'   edge = "#34495E"
#' )
c4_theme <- function(name = "custom",
                     bg = "white",
                     person = "#08427B",
                     system = "#1168BD",
                     container = "#438DD5",
                     component = "#85BBF0",
                     external_system = "#999999",
                     edge = "#666666",
                     group_border = "#CCCCCC") {
  theme <- list(
    name = name,
    bg = bg,
    person = person,
    system = system,
    container = container,
    component = component,
    external_system = external_system,
    edge = edge,
    group_border = group_border
  )

  class(theme) <- c("c4_theme", "list")
  theme
}

#' Modify an existing C4 theme
#'
#' Create a new theme based on an existing one with some colors changed
#'
#' @param base_theme Base theme name ("default", "dark", "blue") or a c4_theme object
#' @param ... Named color parameters to override
#' @return A modified theme object
#' @export
#' @examples
#' # Modify the dark theme
#' my_theme <- c4_modify_theme("dark",
#'   system = "#1E3A8A",
#'   edge = "#60A5FA"
#' )
c4_modify_theme <- function(base_theme, ...) {
  # Get base theme colors
  if (is.character(base_theme)) {
    base_colors <- get_c4_theme(base_theme)
    theme_name <- paste0(base_theme, "_modified")
  } else if (inherits(base_theme, "c4_theme")) {
    base_colors <- base_theme
    theme_name <- paste0(base_theme$name %||% "custom", "_modified")
  } else {
    cli::cli_abort("{.arg base_theme} must be a theme name or c4_theme object")
  }

  # Override with new values
  overrides <- list(...)
  for (param in names(overrides)) {
    if (param %in% names(base_colors)) {
      base_colors[[param]] <- overrides[[param]]
    } else {
      cli::cli_warn("Unknown theme parameter: {.field {param}}")
    }
  }

  base_colors$name <- theme_name
  class(base_colors) <- c("c4_theme", "list")
  base_colors
}

#' Save a custom theme for later use
#'
#' @param theme A c4_theme object
#' @param file File path to save theme (as RDS)
#' @return Invisible file path
#' @export
c4_save_theme <- function(theme, file) {
  if (!inherits(theme, "c4_theme")) {
    cli::cli_abort("{.arg theme} must be a c4_theme object")
  }

  # Add .rds extension if not present
  if (!grepl("\\.rds$", file)) {
    file <- paste0(file, ".rds")
  }

  # Create directory if it doesn't exist
  dir <- dirname(file)
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }

  saveRDS(theme, file)
  cli::cli_alert_success("Saved theme '{theme$name}' to {.file {file}}")
  invisible(file)
}

#' Load a custom theme from file
#'
#' @param file File path to load theme from (RDS file)
#' @return A c4_theme object
#' @export
c4_load_theme <- function(file) {
  # Add .rds extension if not present
  if (!grepl("\\.rds$", file) && !file.exists(file)) {
    file <- paste0(file, ".rds")
  }

  if (!file.exists(file)) {
    cli::cli_abort("Theme file not found: {.file {file}}")
  }

  theme <- readRDS(file)

  if (!inherits(theme, "c4_theme")) {
    cli::cli_abort("File does not contain a valid c4_theme object")
  }

  cli::cli_alert_success("Loaded theme '{theme$name}' from {.file {file}}")
  theme
}

#' List all built-in themes
#'
#' @return Character vector of theme names
#' @export
c4_list_themes <- function() {
  built_in <- c("default", "dark", "blue")
  cli::cli_h2("Built-in themes")
  cli::cli_ul(built_in)
  invisible(built_in)
}

#' Preview a theme's colors
#'
#' @param theme Theme name or c4_theme object
#' @return Invisible theme object (prints color preview)
#' @export
c4_preview_theme <- function(theme) {
  if (is.character(theme)) {
    colors <- get_c4_theme(theme)
    theme_name <- theme
  } else if (inherits(theme, "c4_theme")) {
    colors <- theme
    theme_name <- theme$name %||% "custom"
  } else {
    cli::cli_abort("{.arg theme} must be a theme name or c4_theme object")
  }

  cli::cli_h2("Theme: {theme_name}")
  cli::cli_text("")

  for (elem in names(colors)) {
    if (elem != "name") {
      # Display color name and hex value
      cli::cli_text("{.field {elem}}: {.val {colors[[elem]]}}")
    }
  }

  invisible(colors)
}

#' Apply theme to diagram (internal helper)
#'
#' This modifies the helper function to accept custom themes
#'
#' @param theme Theme name or c4_theme object
#' @keywords internal
get_c4_theme_extended <- function(theme) {
  # If theme is already a c4_theme object, return it
  if (inherits(theme, "c4_theme")) {
    return(theme)
  }

  # Otherwise use the original get_c4_theme function
  get_c4_theme(theme)
}
