# Comprehensive c4r Example
# Demonstrates all new features

library(c4r)

# ============================================================================
# 1. TIBBLE INPUT - Simplified Element Creation
# ============================================================================

library(tibble)

# Create persons from tibble
persons_df <- tribble(
  ~id,       ~label,      ~description,
  "customer", "Customer",  "Online shopper",
  "admin",    "Admin",     "System administrator"
)
persons <- c4_persons_from_tibble(persons_df)

# Create systems from tibble
systems_df <- tribble(
  ~id,    ~label,             ~description,                    ~technology,
  "shop", "E-Commerce Shop",  "Online shopping platform",      "React + Node.js",
  "crm",  "CRM System",       "Customer relationship mgmt",    "Salesforce"
)
systems <- c4_systems_from_tibble(systems_df)

# Create relationships from tibble
rels_df <- tribble(
  ~from,      ~to,    ~label,              ~technology,
  "customer", "shop", "Browses products",  "HTTPS",
  "admin",    "shop", "Manages",           "HTTPS",
  "shop",     "crm",  "Syncs customers",   "REST API"
)
relationships <- c4_rels_from_tibble(rels_df)

# ============================================================================
# 2. VALIDATION - Check Diagram Before Creation
# ============================================================================

# Validate elements and relationships
check_c4_elements(
  person = persons,
  system = systems,
  relationships = relationships
)

# Get summary statistics
stats <- c4_summary(
  elements = list(person = persons, system = systems),
  relationships = relationships
)
print(stats)

# ============================================================================
# 3. CUSTOM THEME - Create Corporate Branding
# ============================================================================

# Create a custom theme
corporate_theme <- c4_theme(
  name = "corporate",
  bg = "#FFFFFF",
  person = "#E74C3C",
  system = "#3498DB",
  container = "#2ECC71",
  component = "#F39C12",
  external_system = "#95A5A6",
  edge = "#34495E"
)

# Preview the theme
c4_preview_theme(corporate_theme)

# Or modify an existing theme
dark_blue <- c4_modify_theme("dark",
                              system = "#1E3A8A",
                              edge = "#60A5FA")

# ============================================================================
# 4. FLUENT BUILDER INTERFACE - Chainable API
# ============================================================================

diagram_builder <- c4_builder(title = "E-Commerce System", theme = corporate_theme) %>%
  # Add people
  add_person("user", "Customer", "Online shopper") %>%
  add_person("admin", "Administrator", "System admin") %>%
  # Add containers
  add_container("web", "Web App", "Customer-facing UI", "React") %>%
  add_container("api", "API Gateway", "Backend services", "Node.js") %>%
  add_container("db", "Database", "Persistent storage", "PostgreSQL") %>%
  add_container("cache", "Cache", "Session cache", "Redis") %>%
  # Add external systems
  add_external_system("payment", "Payment Gateway", "Stripe") %>%
  add_external_system("email", "Email Service", "SendGrid") %>%
  # Add relationships
  add_relationship("user", "web", "Uses", "HTTPS") %>%
  add_relationship("admin", "web", "Manages", "HTTPS") %>%
  add_relationship("web", "api", "Calls", "REST/JSON") %>%
  add_relationship("api", "db", "Reads/Writes", "SQL") %>%
  add_relationship("api", "cache", "Caches", "Redis Protocol") %>%
  add_relationship("api", "payment", "Processes payments", "REST API") %>%
  add_relationship("api", "email", "Sends notifications", "SMTP") %>%
  # Add groups
  add_group("backend", "Backend Services",
            members = c("api", "db", "cache"),
            style = "dashed")

# Build the diagram
container_diagram <- diagram_builder %>% build_container()

# Print builder info
print(diagram_builder)

# ============================================================================
# 5. ADVANCED RELATIONSHIPS - Different Types and Styles
# ============================================================================

advanced_diagram <- c4_builder(title = "Microservices with Advanced Relationships") %>%
  add_container("api", "API Gateway", "Entry point", "Kong") %>%
  add_container("order_svc", "Order Service", "Order processing", "Java") %>%
  add_container("queue", "Message Queue", "Event bus", "RabbitMQ") %>%
  add_container("notification_svc", "Notification Service", "Sends alerts", "Python") %>%
  # Sync relationship
  add_relationship("api", "order_svc", "1. Create order",
                   technology = "HTTP", type = "sync", style = "solid") %>%
  # Async relationship
  add_relationship("order_svc", "queue", "2. Publish event",
                   type = "async", style = "dashed") %>%
  add_relationship("queue", "notification_svc", "3. Consume event",
                   type = "async", style = "dashed") %>%
  build_container()

# ============================================================================
# 6. TEMPLATES - Quick Architecture Patterns
# ============================================================================

# List available templates
c4_list_templates()

# Create microservices architecture from template
microservices <- c4_from_template("microservices",
  services = c("api", "auth", "users", "orders"),
  databases = c("postgres", "redis"),
  message_queue = "rabbitmq"
)

# Create three-tier architecture
three_tier <- c4_from_template("three_tier",
  web_tech = "React",
  app_tech = "Spring Boot",
  db_tech = "MySQL"
)

# Create serverless architecture
serverless <- c4_from_template("serverless",
  functions = c("api", "processor"),
  storage = TRUE,
  database = TRUE
)

# ============================================================================
# 7. EXPORT - Multiple Formats
# ============================================================================

# Export to PNG (requires DiagrammeRsvg and rsvg packages)
# export_c4(container_diagram, "my_architecture", format = "png", width = 1200, height = 800)

# Export to SVG
# export_c4(container_diagram, "my_architecture", format = "svg")

# Export to multiple formats at once
# export_c4_all(container_diagram, "my_architecture", formats = c("png", "svg", "html"))

# Export DOT notation
# export_c4_dot(container_diagram, "my_architecture.dot")

# ============================================================================
# 8. CODE GENERATION - Export as R Code
# ============================================================================

# Generate R code from elements
code <- diagram_to_code(
  elements = list(
    person = persons,
    system = systems
  ),
  relationships = relationships,
  title = "Generated Diagram",
  theme = "default",
  diagram_type = "context"
)

# Print the generated code
cat(code)

# Save to file
# save_code(code, "generated_diagram.R")

# ============================================================================
# 9. YAML IMPORT/EXPORT
# ============================================================================

# Export to YAML (requires yaml package)
# diagram_to_yaml(
#   elements = list(person = persons, system = systems),
#   relationships = relationships,
#   file = "diagram.yaml"
# )

# Import from YAML
# imported <- diagram_from_yaml("diagram.yaml")

# ============================================================================
# 10. GROUPING AND BOUNDARIES
# ============================================================================

grouped_diagram <- c4_context(
  title = "System with Boundaries",
  person = list(
    c4_person("user", "User", "Application user")
  ),
  system = list(
    c4_system("app1", "App 1", "First app", "Java"),
    c4_system("app2", "App 2", "Second app", "Python"),
    c4_system("app3", "App 3", "Third app", "Go")
  ),
  external_system = list(
    c4_external_system("ext", "External API", "Third-party service")
  ),
  relationships = list(
    c4_rel("user", "app1", "Uses"),
    c4_rel("app1", "app2", "Calls"),
    c4_rel("app2", "app3", "Calls"),
    c4_rel("app3", "ext", "Queries")
  ),
  groups = list(
    c4_deployment_boundary("cloud", "Cloud Platform",
                          members = c("app1", "app2", "app3")),
    c4_system_boundary("core", "Core Systems",
                      members = c("app1", "app2"))
  ),
  theme = "blue"
)

# ============================================================================
# 11. VALIDATION AND DEBUGGING
# ============================================================================

# Find orphaned elements (no relationships)
orphaned <- c4_find_orphaned(
  elements = list(
    person = list(c4_person("user", "User", "A user")),
    system = list(
      c4_system("app1", "App 1", "First app"),
      c4_system("app2", "App 2", "Second app - never used!")
    )
  ),
  relationships = list(
    c4_rel("user", "app1", "Uses")
  )
)
print(paste("Orphaned elements:", paste(orphaned, collapse = ", ")))

# Find invalid relationships
invalid <- c4_find_invalid_rels(
  elements = list(
    person = list(c4_person("user", "User", "A user"))
  ),
  relationships = list(
    c4_rel("user", "nonexistent", "Tries to use")
  )
)
print(invalid)

# ============================================================================
# Summary
# ============================================================================

cat("\n=== c4r Comprehensive Example Complete ===\n")
cat("Features demonstrated:\n")
cat("1. Tibble input for simplified element creation\n")
cat("2. Validation and debugging tools\n")
cat("3. Custom themes and theme modification\n")
cat("4. Fluent builder interface\n")
cat("5. Advanced relationship types\n")
cat("6. Architecture templates\n")
cat("7. Multi-format export\n")
cat("8. Code generation\n")
cat("9. YAML import/export\n")
cat("10. Visual grouping and boundaries\n")
cat("11. Validation helpers\n")
