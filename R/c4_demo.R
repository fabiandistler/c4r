# Demo and examples ------------------------------------------------------

#' Demo C4 diagrams
#'
#' Creates example C4 diagrams to demonstrate package functionality.
#'
#' @return A list of example C4 diagrams
#' @export
#' @examples
#' \dontrun{
#' demos <- c4_demo()
#' demos$context # View context diagram
#' demos$container # View container diagram
#' demos$component # View component diagram
#' }
c4_demo <- function() {
  # System Context Example
  context_demo <- c4_context(
    title = "E-Commerce System - System Context",
    person = list(
      c4_person("customer", "Customer", "A person who wants to buy products online"),
      c4_person("admin", "Administrator", "Manages the e-commerce system")
    ),
    system = list(
      c4_system(
        "ecommerce", "E-Commerce System",
        "Allows customers to buy products online and admins to manage inventory"
      )
    ),
    external_system = list(
      c4_external_system(
        "payment", "Payment System",
        "Processes credit card payments"
      ),
      c4_external_system(
        "email", "Email System",
        "Sends emails to customers"
      )
    ),
    relationships = list(
      c4_rel("customer", "ecommerce", "Views products, makes purchases", "HTTPS"),
      c4_rel("admin", "ecommerce", "Manages products and orders", "HTTPS"),
      c4_rel("ecommerce", "payment", "Processes payments", "REST API"),
      c4_rel("ecommerce", "email", "Sends order confirmations", "SMTP")
    ),
    theme = "default"
  )

  # Container Example
  container_demo <- c4_container(
    title = "E-Commerce System - Container Diagram",
    person = list(
      c4_person("customer", "Customer", "Buys products online")
    ),
    container = list(
      c4_container(
        "web", "Web Application",
        "Provides e-commerce functionality", "React"
      ),
      c4_container(
        "api", "API Gateway",
        "Handles API requests", "Node.js"
      ),
      c4_container(
        "db", "Database",
        "Stores product and order data", "PostgreSQL"
      ),
      c4_container(
        "cache", "Cache",
        "Caches frequently accessed data", "Redis"
      )
    ),
    external_system = list(
      c4_external_system(
        "payment", "Payment System",
        "Processes payments"
      )
    ),
    relationships = list(
      c4_rel("customer", "web", "Uses", "HTTPS"),
      c4_rel("web", "api", "Makes API calls", "REST/HTTPS"),
      c4_rel("api", "db", "Reads/writes data", "SQL"),
      c4_rel("api", "cache", "Caches data", "Redis Protocol"),
      c4_rel("api", "payment", "Processes payments", "REST API")
    )
  )

  # Component Example
  component_demo <- c4_component(
    title = "API Gateway - Component Diagram",
    component = list(
      c4_component(
        "controller", "Order Controller",
        "Handles order-related requests", "Express.js"
      ),
      c4_component(
        "service", "Order Service",
        "Business logic for orders", "Node.js"
      ),
      c4_component(
        "repository", "Order Repository",
        "Data access for orders", "Sequelize ORM"
      ),
      c4_component(
        "validator", "Input Validator",
        "Validates incoming requests", "Joi"
      )
    ),
    external_system = list(
      c4_external_system("db", "Database", "PostgreSQL database"),
      c4_external_system("payment", "Payment API", "External payment service")
    ),
    relationships = list(
      c4_rel("controller", "validator", "Validates input", "Function call"),
      c4_rel("controller", "service", "Calls business logic", "Function call"),
      c4_rel("service", "repository", "Persists data", "Function call"),
      c4_rel("repository", "db", "Executes queries", "SQL"),
      c4_rel("service", "payment", "Processes payments", "REST API")
    )
  )

  list(
    context = context_demo,
    container = container_demo,
    component = component_demo
  )
}
