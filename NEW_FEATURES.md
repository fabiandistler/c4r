# c4r New Features - Version 0.2.0

This document describes all new features added to make c4r more
user-friendly.

## Quick Start with New Features

``` r
library(c4r)

# Use the fluent builder interface
diagram <- c4_builder("My System") %>%
  add_person("user", "User", "Application user") %>%
  add_system("app", "Application", "Main system", "React") %>%
  add_relationship("user", "app", "Uses", "HTTPS") %>%
  build_context()
```

## Feature Overview

### 1. Tibble/DataFrame Input 📊

Easily create multiple elements from data frames:

``` r
library(tibble)

# Create persons from tibble
persons <- tribble(
  ~id,     ~label,    ~description,
  "user1", "User 1",  "First user",
  "user2", "User 2",  "Second user"
) %>% c4_persons_from_tibble()

# Create relationships from tibble
rels <- tribble(
  ~from,  ~to,   ~label,   ~technology,
  "user", "app", "Uses",   "HTTPS",
  "app",  "db",  "Reads",  "SQL"
) %>% c4_rels_from_tibble()
```

**Functions:** - `c4_persons_from_tibble()` -
`c4_systems_from_tibble()` - `c4_containers_from_tibble()` -
`c4_components_from_tibble()` - `c4_external_systems_from_tibble()` -
`c4_rels_from_tibble()`

### 2. Validation & Debugging Tools ✅

Catch errors before creating diagrams:

``` r
# Validate elements and relationships
check_c4_elements(
  person = my_persons,
  system = my_systems,
  relationships = my_rels
)

# Get summary statistics
stats <- c4_summary(
  elements = list(person = my_persons, system = my_systems),
  relationships = my_rels
)

# Find orphaned elements
orphaned <- c4_find_orphaned(elements, relationships)

# Find invalid relationships
invalid <- c4_find_invalid_rels(elements, relationships)
```

### 3. Custom Themes 🎨

Create and customize color themes:

``` r
# Create a custom theme
my_theme <- c4_theme(
  name = "corporate",
  bg = "#FFFFFF",
  person = "#E74C3C",
  system = "#3498DB",
  edge = "#34495E"
)

# Use the theme
diagram <- c4_context(..., theme = my_theme)

# Modify existing theme
dark_blue <- c4_modify_theme("dark",
                              system = "#1E3A8A",
                              edge = "#60A5FA")

# Save and load themes
c4_save_theme(my_theme, "~/.c4r/themes/corporate.rds")
loaded_theme <- c4_load_theme("~/.c4r/themes/corporate.rds")

# Preview theme colors
c4_preview_theme(my_theme)

# List built-in themes
c4_list_themes()
```

### 4. Fluent Builder Interface ⛓️

Chainable API for building diagrams:

``` r
diagram <- c4_builder(title = "My System", theme = "blue") %>%
  # Add elements
  add_person("user", "User", "Application user") %>%
  add_system("app", "App", "Main application", "React") %>%
  add_container("api", "API", "Backend API", "Node.js") %>%
  add_external_system("payment", "Payment", "Stripe") %>%

  # Add relationships
  add_relationship("user", "app", "Uses", "HTTPS") %>%
  add_relationship("app", "api", "Calls", "REST") %>%
  add_relationship("api", "payment", "Processes", "API") %>%

  # Add groups
  add_group("backend", "Backend",
            members = c("api"),
            style = "dashed") %>%

  # Build diagram
  build_context()  # or build_container() or build_component()

# Print builder status
print(diagram)
```

**Builder Functions:** - `c4_builder()` - Initialize builder -
`set_title()`, `set_theme()` - Set properties - `add_person()`,
`add_system()`, `add_container()`, `add_component()`,
`add_external_system()` - Add elements - `add_relationship()` - Add
relationships - `add_group()` - Add visual grouping - `build_context()`,
`build_container()`, `build_component()` - Build diagram

### 5. Visual Grouping & Boundaries 📦

Group related elements with visual boundaries:

``` r
diagram <- c4_context(
  ...,
  groups = list(
    c4_group("cloud", "Cloud Platform",
             members = c("app", "db", "cache"),
             style = "dashed"),
    c4_deployment_boundary("aws", "AWS",
                          members = c("app", "db")),
    c4_system_boundary("core", "Core System",
                      members = c("app"))
  )
)
```

**Group Functions:** - `c4_group()` - Create generic group -
`c4_deployment_boundary()` - Deployment/infrastructure boundary -
`c4_system_boundary()` - System boundary

**Styles:** `"solid"`, `"dashed"`, `"dotted"`, `"bold"`

### 6. Advanced Relationship Types 🔗

Different relationship styles and types:

``` r
# Synchronous relationship
rel1 <- c4_rel_advanced("api", "db", "Queries", "SQL",
                        type = "sync", style = "solid")

# Asynchronous relationship
rel2 <- c4_rel_advanced("api", "queue", "Publishes", "AMQP",
                        type = "async", style = "dashed")

# Bidirectional relationship
rel3 <- c4_rel_bidirectional("service1", "service2", "Syncs", "gRPC")

# Or use convenience function
rel4 <- c4_rel_async("worker", "queue", "Subscribes", "RabbitMQ")
```

**Types:** `"sync"`, `"async"`, `"request-response"` **Styles:**
`"solid"`, `"dashed"`, `"dotted"` **Directions:** `"forward"`, `"back"`,
`"both"`, `"none"`

### 7. Multi-Format Export 📤

Export diagrams to PNG, SVG, PDF, HTML:

``` r
# Export to PNG
export_c4(diagram, "architecture", format = "png", width = 1200, height = 800, dpi = 300)

# Export to SVG
export_c4(diagram, "architecture", format = "svg")

# Export to PDF
export_c4(diagram, "architecture", format = "pdf")

# Export to HTML
export_c4(diagram, "architecture", format = "html")

# Export to multiple formats at once
export_c4_all(diagram, "architecture", formats = c("png", "svg", "pdf"))

# Export DOT notation
export_c4_dot(diagram, "architecture.dot")

# Get DOT code
dot_code <- c4_get_dot(diagram)
```

**Note:** PNG, SVG, and PDF export require `DiagrammeRsvg` and `rsvg`
packages.

### 8. Architecture Templates 🏗️

Quick start with common patterns:

``` r
# List available templates
c4_list_templates()

# Microservices architecture
diagram <- c4_from_template("microservices",
  services = c("api", "auth", "users", "orders"),
  databases = c("postgres", "redis"),
  message_queue = "rabbitmq"
)

# Monolithic architecture
diagram <- c4_from_template("monolith",
  app_name = "My App",
  database = "postgres",
  cache = "redis"
)

# Three-tier architecture
diagram <- c4_from_template("three_tier",
  web_tech = "React",
  app_tech = "Spring Boot",
  db_tech = "MySQL"
)

# Serverless architecture
diagram <- c4_from_template("serverless",
  functions = c("api", "processor"),
  storage = TRUE,
  database = TRUE
)

# Data pipeline
diagram <- c4_from_template("data_pipeline",
  sources = c("api", "files"),
  processing = c("etl"),
  storage = c("warehouse")
)

# Save custom template
c4_save_template(my_diagram, "my_pattern", "~/templates/pattern.rds",
                 parameters = list(num_services = 3))
```

### 9. Code Generation 💻

Export diagrams as R code or YAML:

``` r
# Generate R code
code <- diagram_to_code(
  elements = list(person = my_persons, system = my_systems),
  relationships = my_rels,
  title = "My System",
  theme = "default",
  diagram_type = "context"
)

# Print the code
cat(code)

# Save to file
save_code(code, "diagram.R")

# Export to YAML
diagram_to_yaml(
  elements = list(person = my_persons),
  relationships = my_rels,
  file = "diagram.yaml"
)

# Import from YAML
imported <- diagram_from_yaml("diagram.yaml")
```

## Migration Guide

### Old Way

``` r
# Old: Verbose element creation
person1 <- c4_person("user1", "User 1", "First user")
person2 <- c4_person("user2", "User 2", "Second user")
person3 <- c4_person("user3", "User 3", "Third user")

rel1 <- c4_rel("user1", "app", "Uses")
rel2 <- c4_rel("user2", "app", "Uses")
rel3 <- c4_rel("user3", "app", "Uses")

diagram <- c4_context(
  title = "My System",
  person = list(person1, person2, person3),
  system = list(app),
  relationships = list(rel1, rel2, rel3)
)
```

### New Way

``` r
# New: Tibble input + Builder
diagram <- c4_builder("My System") %>%
  # Add multiple persons at once from tibble
  tribble(
    ~id,     ~label,    ~description,
    "user1", "User 1",  "First user",
    "user2", "User 2",  "Second user",
    "user3", "User 3",  "Third user"
  ) %>%
  c4_persons_from_tibble() %>%
  { Reduce(function(b, p) add_person(b, p$id, p$label, p$description), ., init = .) } %>%

  add_system("app", "App", "Application") %>%
  add_relationship("user1", "app", "Uses") %>%
  add_relationship("user2", "app", "Uses") %>%
  add_relationship("user3", "app", "Uses") %>%
  build_context()

# Or even simpler with templates
diagram <- c4_from_template("three_tier")
```

## Complete Example

See `inst/examples/comprehensive_example.R` for a complete working
example demonstrating all features.

## Breaking Changes

None! All new features are additions. Existing code continues to work.

## Requirements

### Core Features

All new features work with existing dependencies.

### Optional Features

- **PNG/SVG/PDF Export**: Requires `DiagrammeRsvg` and `rsvg`

  ``` r
  install.packages(c("DiagrammeRsvg", "rsvg"))
  ```

- **YAML Import/Export**: Requires `yaml`

  ``` r
  install.packages("yaml")
  ```

- **HTML Export**: Requires `htmlwidgets`

  ``` r
  install.packages("htmlwidgets")
  ```

## What’s Next?

See `FEATURE_MAP.md` for planned features in future releases: -
Interactive diagrams (Shiny integration) - Diagram comparison and
versioning - Import from external formats (Structurizr, PlantUML) -
RStudio Addin - And more!

## Feedback

Found a bug or have a feature request? Please open an issue at:
<https://github.com/fabiandistler/c4r/issues>
