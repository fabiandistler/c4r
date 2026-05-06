# RStudio addin entry points ----------------------------------------------

#' Insert a c4 chunk at the cursor (RStudio addin)
#'
#' Inserts a starter c4 knitr chunk at the cursor position in the active
#' RStudio document. Available as the addin "Insert C4 chunk".
#'
#' @return Invisibly returns the inserted text. Side-effect only.
#' @export
insert_c4_chunk <- function() {
  if (!requireNamespace("rstudioapi", quietly = TRUE) || !rstudioapi::isAvailable()) {
    cli::cli_abort("This addin requires RStudio with the {.pkg rstudioapi} package.")
  }
  text <- paste(c(
    "```{c4, type=\"container\", title=\"My App\"}",
    "person: user \"End User\"",
    "container: api \"API\" \"REST endpoint\" [Service]",
    "container: db \"Database\" \"App data\" [Postgres]",
    "rel: user -> api \"Uses\" [HTTPS]",
    "rel: api -> db \"Reads/Writes\" [SQL]",
    "```",
    ""
  ), collapse = "\n")
  rstudioapi::insertText(text = text)
  invisible(text)
}

#' Insert a c4 template chunk at the cursor (RStudio addin)
#'
#' Prompts the user for a template name (see [c4_list_templates()]) and
#' inserts an R chunk that renders that template. Available as the addin
#' "Insert C4 template".
#'
#' @return Invisibly returns the inserted text.
#' @export
insert_c4_template <- function() {
  if (!requireNamespace("rstudioapi", quietly = TRUE) || !rstudioapi::isAvailable()) {
    cli::cli_abort("This addin requires RStudio with the {.pkg rstudioapi} package.")
  }
  templates <- c("microservices", "monolith", "serverless", "three_tier", "data_pipeline")
  choice <- rstudioapi::showPrompt(
    title = "C4 template",
    message = paste0("Template name (one of: ", paste(templates, collapse = ", "), ")"),
    default = "three_tier"
  )
  if (is.null(choice) || !nzchar(choice)) {
    return(invisible(NULL))
  }
  if (!choice %in% templates) {
    cli::cli_warn("Unknown template {.val {choice}}; inserting anyway.")
  }
  text <- paste(c(
    "```{r}",
    paste0("c4r::c4_from_template(\"", choice, "\")"),
    "```",
    ""
  ), collapse = "\n")
  rstudioapi::insertText(text = text)
  invisible(text)
}
