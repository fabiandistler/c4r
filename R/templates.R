# Diagram templates ------------------------------------------------------

#' Create a diagram from a template
#'
#' Generate a C4 diagram using common architecture patterns
#'
#' @param template Template name: "microservices", "monolith", "serverless", "three_tier"
#' @param ... Template-specific parameters
#' @return A DiagrammeR graph object
#' @export
#' @examples
#' \dontrun{
#' # Create a microservices architecture
#' diagram <- c4_from_template("microservices",
#'   services = c("api", "auth", "users"),
#'   databases = c("postgres", "redis"),
#'   message_queue = "rabbitmq"
#' )
#' }
c4_from_template <- function(template = c("microservices", "monolith", "serverless", "three_tier", "data_pipeline"), ...) {
  template <- match.arg(template)

  switch(template,
    "microservices" = template_microservices(...),
    "monolith" = template_monolith(...),
    "serverless" = template_serverless(...),
    "three_tier" = template_three_tier(...),
    "data_pipeline" = template_data_pipeline(...)
  )
}

#' Microservices template
#' @param services Character vector of service names
#' @param databases Character vector of database names
#' @param message_queue Message queue type (optional)
#' @param api_gateway Include API gateway
#' @param title Diagram title
#' @keywords internal
template_microservices <- function(services = c("service1", "service2"),
                                   databases = c("postgres"),
                                   message_queue = NULL,
                                   api_gateway = TRUE,
                                   title = "Microservices Architecture") {
  builder <- c4_builder(title = title)

  # Add user
  builder <- builder %>%
    add_person("user", "User", "Application user")

  # Add API Gateway if requested
  if (api_gateway) {
    builder <- builder %>%
      add_container("api_gateway", "API Gateway", "Routes requests", "Kong/NGINX") %>%
      add_relationship("user", "api_gateway", "Makes requests", "HTTPS")
  }

  # Add services
  for (svc in services) {
    builder <- builder %>%
      add_container(svc, tools::toTitleCase(svc), glue::glue("{tools::toTitleCase(svc)} microservice"), "Docker")

    if (api_gateway) {
      builder <- builder %>%
        add_relationship("api_gateway", svc, "Routes to", "HTTP")
    } else {
      builder <- builder %>%
        add_relationship("user", svc, "Uses", "HTTP")
    }
  }

  # Add databases
  for (db in databases) {
    builder <- builder %>%
      add_container(db, tools::toTitleCase(db), "Database", tools::toTitleCase(db))

    # Connect first service to each database
    if (length(services) > 0) {
      builder <- builder %>%
        add_relationship(services[1], db, "Reads/Writes", "SQL")
    }
  }

  # Add message queue
  if (!is.null(message_queue)) {
    builder <- builder %>%
      add_container("queue", "Message Queue", "Event bus", tools::toTitleCase(message_queue))

    # Connect services to queue
    for (svc in services) {
      builder <- builder %>%
        add_relationship(svc, "queue", "Publishes events", "AMQP")
    }
  }

  builder %>% build_container()
}

#' Monolith template
#' @param title Diagram title
#' @param app_name Application name
#' @param database Database type
#' @param cache Cache type (optional)
#' @keywords internal
template_monolith <- function(title = "Monolithic Architecture",
                              app_name = "Application",
                              database = "postgres",
                              cache = NULL) {
  builder <- c4_builder(title = title) %>%
    add_person("user", "User", "Application user") %>%
    add_system("app", app_name, "Monolithic application", "Java/Spring") %>%
    add_container("db", "Database", "Data storage", tools::toTitleCase(database)) %>%
    add_relationship("user", "app", "Uses", "HTTPS") %>%
    add_relationship("app", "db", "Reads/Writes", "JDBC")

  if (!is.null(cache)) {
    builder <- builder %>%
      add_container("cache", "Cache", "Session & data cache", tools::toTitleCase(cache)) %>%
      add_relationship("app", "cache", "Caches data", "Redis Protocol")
  }

  builder %>% build_context()
}

#' Serverless template
#' @param title Diagram title
#' @param functions Character vector of function types
#' @param storage Include storage
#' @param database Include database
#' @keywords internal
template_serverless <- function(title = "Serverless Architecture",
                                functions = c("api", "processor"),
                                storage = TRUE,
                                database = TRUE) {
  builder <- c4_builder(title = title) %>%
    add_person("user", "User", "Application user")

  # Add API function
  if ("api" %in% functions) {
    builder <- builder %>%
      add_component("api_function", "API Function", "REST API handler", "AWS Lambda") %>%
      add_relationship("user", "api_function", "Invokes", "API Gateway")
  }

  # Add processor function
  if ("processor" %in% functions) {
    builder <- builder %>%
      add_component("processor_function", "Processor", "Event processor", "AWS Lambda")
  }

  # Add storage
  if (storage) {
    builder <- builder %>%
      add_external_system("storage", "Object Storage", "File storage (S3)")

    if ("api" %in% functions) {
      builder <- builder %>%
        add_relationship("api_function", "storage", "Stores files", "S3 API")
    }
  }

  # Add database
  if (database) {
    builder <- builder %>%
      add_external_system("db", "Database", "Managed database (DynamoDB)")

    if ("api" %in% functions) {
      builder <- builder %>%
        add_relationship("api_function", "db", "Queries", "DynamoDB API")
    }
  }

  builder %>% build_component()
}

#' Three-tier architecture template
#' @param title Diagram title
#' @param web_tech Web technology
#' @param app_tech Application technology
#' @param db_tech Database technology
#' @keywords internal
template_three_tier <- function(title = "Three-Tier Architecture",
                                web_tech = "React",
                                app_tech = "Node.js",
                                db_tech = "PostgreSQL") {
  c4_builder(title = title) %>%
    add_person("user", "User", "Application user") %>%
    add_container("web", "Web Application", "Frontend", web_tech) %>%
    add_container("app", "Application Server", "Business logic", app_tech) %>%
    add_container("db", "Database", "Data persistence", db_tech) %>%
    add_relationship("user", "web", "Views", "HTTPS") %>%
    add_relationship("web", "app", "Makes API calls", "REST/JSON") %>%
    add_relationship("app", "db", "Reads/Writes", "SQL") %>%
    add_group("backend", "Backend", members = c("app", "db"), style = "dashed") %>%
    build_container()
}

#' Data pipeline template
#' @param title Diagram title
#' @param sources Character vector of data sources
#' @param processing Character vector of processing components
#' @param storage Character vector of storage types
#' @keywords internal
template_data_pipeline <- function(title = "Data Pipeline",
                                   sources = c("api", "files"),
                                   processing = c("etl"),
                                   storage = c("warehouse")) {
  builder <- c4_builder(title = title)

  # Add data sources
  for (src in sources) {
    builder <- builder %>%
      add_external_system(src, tools::toTitleCase(src), glue::glue("Data source: {src}"))
  }

  # Add processing components
  for (proc in processing) {
    builder <- builder %>%
      add_component(proc, toupper(proc), glue::glue("{toupper(proc)} processor"), "Apache Spark")

    # Connect to first source
    if (length(sources) > 0) {
      builder <- builder %>%
        add_relationship(sources[1], proc, "Sends data", "HTTP")
    }
  }

  # Add storage
  for (store in storage) {
    builder <- builder %>%
      add_component(store, tools::toTitleCase(store), "Data storage", "S3/Redshift")

    # Connect from processing
    if (length(processing) > 0) {
      builder <- builder %>%
        add_relationship(processing[1], store, "Stores results", "S3 API")
    }
  }

  builder %>% build_component()
}

#' List available templates
#'
#' @return Character vector of template names
#' @export
c4_list_templates <- function() {
  templates <- c("microservices", "monolith", "serverless", "three_tier", "data_pipeline")

  cli::cli_h2("Available templates")
  cli::cli_ul(templates)

  cli::cli_h3("Template descriptions:")
  cli::cli_text("{.field microservices}: Multiple services with API gateway and message queue")
  cli::cli_text("{.field monolith}: Single application with database")
  cli::cli_text("{.field serverless}: Cloud functions with managed services")
  cli::cli_text("{.field three_tier}: Web, application, and database layers")
  cli::cli_text("{.field data_pipeline}: ETL/data processing flow")

  invisible(templates)
}

#' Save a custom template
#'
#' @param diagram A diagram object
#' @param name Template name
#' @param file File path to save template
#' @param parameters Named list of parameters used to create the template
#' @return Invisible file path
#' @export
c4_save_template <- function(diagram, name, file, parameters = list()) {
  template <- list(
    name = name,
    diagram = diagram,
    parameters = parameters,
    created = Sys.time()
  )

  # Add .rds extension if not present
  if (!grepl("\\.rds$", file)) {
    file <- paste0(file, ".rds")
  }

  saveRDS(template, file)
  cli::cli_alert_success("Saved template '{name}' to {.file {file}}")
  invisible(file)
}
