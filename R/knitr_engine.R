# Knitr engine for c4 chunks ---------------------------------------------

#' Knitr engine for declarative C4 chunks
#'
#' Registered automatically when c4r is loaded. In an R Markdown or Quarto
#' document you can write:
#'
#' ````
#' ```{c4, type="container", title="My App"}
#' person: user "End User"
#' container: api "API" [Service]
#' rel: user -> api "Uses"
#' ```
#' ````
#'
#' Supported lines (one per element):
#' - `person: <id> "<label>" "<description>"`
#' - `system: <id> "<label>" "<description>" [<technology>]`
#' - `container: <id> "<label>" "<description>" [<technology>]`
#' - `component: <id> "<label>" "<description>" [<technology>]`
#' - `external: <id> "<label>" "<description>"`
#' - `rel: <from> -> <to> "<label>" [<technology>]`
#'
#' @param options A knitr chunk options list. Recognises `type` (one of
#'   `"context"`, `"container"`, `"component"`; default `"context"`),
#'   `title`, and `theme`.
#' @return Knitr-rendered output. Not called directly.
#' @export
#' @keywords internal
c4_knitr_engine <- function(options) {
  if (!requireNamespace("knitr", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg knitr} is required to use the c4 chunk engine.")
  }

  type <- options$type %||% "context"
  title <- options$title %||% "C4 Diagram"
  theme <- options$theme %||% "default"
  body <- paste(options$code, collapse = "\n")

  diagram <- c4_render_dsl(body, type = type, title = title, theme = theme)
  knitr::knit_print(diagram, options = options)
}

#' Render a c4 DSL body into a diagram
#'
#' Parses the line-oriented DSL used by [c4_knitr_engine()] and dispatches to
#' the appropriate diagram builder.
#'
#' @param body Character string containing the DSL body.
#' @param type Diagram type: `"context"`, `"container"`, or `"component"`.
#' @param title Diagram title.
#' @param theme Theme name.
#' @return A DiagrammeR htmlwidget.
#' @export
c4_render_dsl <- function(body, type = "context", title = "C4 Diagram", theme = "default") {
  parsed <- parse_c4_dsl(body)
  builder <- c4_builder(title = title, theme = theme)

  for (p in parsed$persons) {
    builder <- add_person(builder, p$id, p$label, p$description)
  }
  for (s in parsed$systems) {
    builder <- add_system(builder, s$id, s$label, s$description, s$technology)
  }
  for (c in parsed$containers) {
    builder <- add_container(builder, c$id, c$label, c$description, c$technology)
  }
  for (cp in parsed$components) {
    builder <- add_component(builder, cp$id, cp$label, cp$description, cp$technology)
  }
  for (e in parsed$external_systems) {
    builder <- add_external_system(builder, e$id, e$label, e$description)
  }
  for (r in parsed$relationships) {
    builder <- add_relationship(builder, r$from, r$to, r$label, r$technology)
  }

  switch(type,
    "context" = build_context(builder),
    "container" = build_container(builder),
    "component" = build_component(builder),
    cli::cli_abort("Unknown diagram type: {.val {type}}")
  )
}

# DSL parser. Tolerant: blank lines and lines starting with '#' are ignored.
parse_c4_dsl <- function(body) {
  lines <- strsplit(body, "\n", fixed = TRUE)[[1]]
  lines <- trimws(lines)
  lines <- lines[nzchar(lines) & !startsWith(lines, "#")]

  out <- list(
    persons = list(), systems = list(), containers = list(),
    components = list(), external_systems = list(), relationships = list()
  )

  for (line in lines) {
    parsed <- parse_dsl_line(line)
    if (is.null(parsed)) next
    out[[parsed$bucket]] <- c(out[[parsed$bucket]], list(parsed$value))
  }
  out
}

parse_dsl_line <- function(line) {
  m <- regmatches(line, regexec("^([a-z_]+)\\s*:\\s*(.*)$", line, perl = TRUE))[[1]]
  if (length(m) != 3) {
    cli::cli_warn("Skipping unparseable c4 line: {.val {line}}")
    return(NULL)
  }
  kind <- m[2]
  rest <- m[3]

  if (kind == "rel") {
    return(parse_rel_line(line, rest))
  }

  bucket <- switch(kind,
    person = "persons",
    system = "systems",
    container = "containers",
    component = "components",
    external = "external_systems",
    NULL
  )
  if (is.null(bucket)) {
    cli::cli_warn("Unknown c4 element kind: {.val {kind}}")
    return(NULL)
  }

  parsed <- parse_element_rest(rest)
  if (is.null(parsed)) {
    cli::cli_warn("Skipping malformed line: {.val {line}}")
    return(NULL)
  }
  list(bucket = bucket, value = parsed)
}

# Parse the rest of an element line: <id> ["label"] ["description"] [tech]
parse_element_rest <- function(rest) {
  rest <- trimws(rest)
  m <- regmatches(rest, regexpr("^\\S+", rest, perl = TRUE))
  if (length(m) != 1 || !nzchar(m)) return(NULL)
  id <- m
  remainder <- trimws(substring(rest, nchar(id) + 1L))

  quoted <- extract_quoted_strings(remainder)
  remainder <- quoted$remainder
  label <- if (length(quoted$values) >= 1) quoted$values[1] else id
  description <- if (length(quoted$values) >= 2) quoted$values[2] else ""

  technology <- ""
  bracket <- regmatches(remainder, regexec("\\[([^\\]]*)\\]", remainder, perl = TRUE))[[1]]
  if (length(bracket) >= 2) {
    technology <- bracket[2]
  }

  list(id = id, label = label, description = description, technology = technology)
}

parse_rel_line <- function(line, rest) {
  rest <- trimws(rest)
  m <- regmatches(rest, regexec("^(\\S+)\\s*->\\s*(\\S+)(.*)$", rest, perl = TRUE))[[1]]
  if (length(m) != 4) {
    cli::cli_warn("Skipping malformed rel line: {.val {line}}")
    return(NULL)
  }
  from <- m[2]; to <- m[3]; remainder <- trimws(m[4])

  quoted <- extract_quoted_strings(remainder)
  label <- if (length(quoted$values) >= 1) quoted$values[1] else ""

  technology <- ""
  bracket <- regmatches(quoted$remainder, regexec("\\[([^\\]]*)\\]", quoted$remainder, perl = TRUE))[[1]]
  if (length(bracket) >= 2) {
    technology <- bracket[2]
  }

  list(bucket = "relationships", value = list(
    from = from, to = to, label = label, technology = technology
  ))
}

# Extract all double-quoted strings from a fragment, returning their contents
# and the remaining text after they're stripped out.
extract_quoted_strings <- function(text) {
  values <- character(0)
  remaining <- text
  repeat {
    m <- regexpr('"([^"]*)"', remaining, perl = TRUE)
    if (m == -1) break
    match_text <- regmatches(remaining, m)
    inner <- sub('^"(.*)"$', "\\1", match_text)
    values <- c(values, inner)
    remaining <- paste0(
      substring(remaining, 1, m - 1),
      substring(remaining, m + attr(m, "match.length"))
    )
  }
  list(values = values, remainder = trimws(remaining))
}
