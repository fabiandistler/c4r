
<!-- README.md is generated from README.Rmd. Please edit that file -->

# c4r

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/c4r)](https://CRAN.R-project.org/package=c4r)
[![R-CMD-check](https://github.com/fabiandistler/c4r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fabiandistler/c4r/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/fabiandistler/c4r/graph/badge.svg)](https://app.codecov.io/gh/fabiandistler/c4r)
<!-- badges: end -->

c4r provides a simple and intuitive R interface for creating C4
architecture diagrams. The C4 model is a popular approach for
visualizing software architecture through four levels of abstraction:
Context, Container, Component, and Code. This package focuses on the
first three levels, helping you create clear, professional diagrams that
communicate your system’s structure effectively.

## What are C4 Diagrams?

The C4 model breaks down software architecture visualization into four
hierarchical levels:

- **System Context**: Shows how your system fits into the overall
  environment
- **Container**: Reveals the major technical building blocks of your
  system  
- **Component**: Zooms into individual containers to show internal
  structure
- **Code**: Details the implementation (not covered by this package)

c4r generates these diagrams using Graphviz DOT notation, rendered
through DiagrammeR, making them perfect for inclusion in R Markdown
documents, Shiny applications, or standalone visualization.

## Installation

You can install the released version of c4r from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("c4r")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("fabiandistler/c4r")
```

## Documentation

Full documentation website on: <https://fabiandistler.github.io/c4r/>

## Quick Start

Here are examples of each diagram type. For a comprehensive tutorial,
see the [Getting Started
guide](https://fabiandistler.github.io/c4r/articles/getting-started.html).

### System Context Diagram

A System Context diagram shows the big picture - your system and how it
interacts with users and other systems. This is the highest level view,
perfect for stakeholder communication.

``` r
library(c4r)
```

``` r
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
```

### Container Diagram

A Container diagram zooms into a system to show the major technical
building blocks. Each container represents a deployable unit like a web
application, database, or microservice.

``` r
container_demo <- c4_container_diagram(
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
```

### Component Diagram

A Component diagram shows the internal structure of a specific
container, breaking it down into components and their interactions. This
level is useful for developers working on a particular part of the
system.

``` r
component_demo <- c4_component_diagram(
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
```

## Key Features

- **Simple API**: Intuitive functions for creating persons, systems,
  containers, and components
- **Multiple Themes**: Built-in color themes (default, dark, blue) with
  consistent styling
- **Flexible Relationships**: Support for labeled connections with
  technology specifications
- **R Integration**: Native DiagrammeR output works seamlessly with R
  Markdown and Shiny
- **Hierarchical Design**: Progressive disclosure from high-level
  context to detailed components

## Learn More

- [Getting Started
  Guide](https://fabiandistler.github.io/c4r/articles/getting-started.html) -
  Comprehensive tutorial
- [Function Reference](https://fabiandistler.github.io/c4r/reference/) -
  Complete API documentation  
- [C4 Model](https://c4model.com/) - Learn about the C4 approach to
  architecture diagrams

## Related Projects

c4r is inspired by other C4 implementations including
[Structurizr](https://structurizr.com/) and [PlantUML
C4](https://github.com/plantuml-stdlib/C4-PlantUML), but designed
specifically for the R ecosystem.
