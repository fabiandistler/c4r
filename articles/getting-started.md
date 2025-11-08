# Getting Started with c4r

``` r
library(c4r)
```

## Introduction

The C4 model provides a simple way to think about and visualize software
architecture. Created by Simon Brown, it breaks down the complexity of
software systems into four hierarchical levels:

1.  **System Context** - The big picture view
2.  **Container** - The major technical building blocks  
3.  **Component** - Internal structure of containers
4.  **Code** - Implementation details (not covered by c4r)

This vignette walks you through creating each type of diagram using c4r,
from basic concepts to practical examples.

## Understanding the C4 Hierarchy

### When to Use Each Diagram Type

- **System Context**: Use when communicating with stakeholders, showing
  how your system fits into the broader environment
- **Container**: Use when planning deployment, showing major technical
  decisions and boundaries
- **Component**: Use when designing or documenting the internal
  structure of a specific container

### Key Concepts

Before diving into examples, let’s understand the core building blocks:

- **Person**: A human user of your system
- **System**: Your software system (the thing you’re building)
- **External System**: Another system that your system interacts with
- **Container**: A deployable/runnable unit (web app, database, etc.)
- **Component**: A grouping of related functionality within a container
- **Relationship**: How elements interact with each other

## System Context Diagrams

A System Context diagram shows your system as a black box, focusing on
the people who use it and the other systems it interacts with.

### Basic Example

Let’s start with a simple e-commerce system:

``` r
# Create the system context diagram
context_diagram <- c4_context(
  title = "E-Commerce System - System Context",

  # Define the people who interact with our system
  person = list(
    c4_person("customer", "Customer", "A person who buys products online"),
    c4_person("admin", "Administrator", "Manages products and orders")
  ),

  # Define our main system
  system = list(
    c4_system(
      "ecommerce", "E-Commerce System",
      "Allows customers to buy products and admins to manage inventory"
    )
  ),

  # Define external systems we depend on
  external_system = list(
    c4_external_system("payment", "Payment Gateway", "Processes credit card payments"),
    c4_external_system("email", "Email Service", "Sends transactional emails")
  ),

  # Define the relationships between elements
  relationships = list(
    c4_rel("customer", "ecommerce", "Browses products and places orders", "HTTPS"),
    c4_rel("admin", "ecommerce", "Manages products and orders", "HTTPS"),
    c4_rel("ecommerce", "payment", "Processes payments", "REST API"),
    c4_rel("ecommerce", "email", "Sends order confirmations", "SMTP")
  )
)

# Display the diagram
context_diagram
```

### Key Points for System Context

- Keep it simple - focus on the big picture
- Show your system as a single box
- Include all types of users (customers, admins, etc.)
- Show key external dependencies
- Use clear, non-technical language for stakeholders

## Container Diagrams

A Container diagram zooms into your system to show the major technical
building blocks. Each container is something that can be deployed
independently.

### E-Commerce Container Example

``` r
container_diagram <- c4_container_diagram(
  title = "E-Commerce System - Container View",

  # Users of the system
  person = list(
    c4_person("customer", "Customer", "Shops for products online"),
    c4_person("admin", "Administrator", "Manages the e-commerce platform")
  ),

  # The containers that make up our system
  container = list(
    c4_container(
      "web_app", "Web Application",
      "Provides e-commerce functionality", "React SPA"
    ),
    c4_container(
      "api", "API Gateway",
      "Handles all business logic and API requests", "Node.js/Express"
    ),
    c4_container(
      "database", "Database",
      "Stores product, order, and user data", "PostgreSQL"
    ),
    c4_container(
      "cache", "Cache",
      "Caches frequently accessed data", "Redis"
    )
  ),

  # External systems (same as context level)
  external_system = list(
    c4_external_system("payment", "Payment Gateway", "Stripe payment processing"),
    c4_external_system("email", "Email Service", "SendGrid email delivery")
  ),

  # Relationships between containers
  relationships = list(
    # User interactions
    c4_rel("customer", "web_app", "Uses", "HTTPS"),
    c4_rel("admin", "web_app", "Administers", "HTTPS"),

    # Internal container relationships
    c4_rel("web_app", "api", "Makes API calls", "JSON/HTTPS"),
    c4_rel("api", "database", "Reads from and writes to", "SQL/TCP"),
    c4_rel("api", "cache", "Reads from and writes to", "Redis Protocol"),

    # External integrations
    c4_rel("api", "payment", "Processes payments", "REST API/HTTPS"),
    c4_rel("api", "email", "Sends emails", "REST API/HTTPS")
  )
)

container_diagram
```

### Container Design Tips

- Each container should be deployable independently
- Think about your deployment architecture
- Include technology choices (React, Node.js, PostgreSQL, etc.)
- Show data stores as containers
- Consider scalability and operational concerns

## Component Diagrams

A Component diagram shows the internal structure of a single container,
breaking it down into components and their interactions.

### API Gateway Component Example

Let’s zoom into the API Gateway container:

``` r
component_diagram <- c4_component_diagram(
  title = "API Gateway - Component View",

  # Components within the API Gateway container
  component = list(
    c4_component(
      "auth_controller", "Authentication Controller",
      "Handles user authentication and authorization", "Express.js"
    ),
    c4_component(
      "product_controller", "Product Controller",
      "Handles product-related requests", "Express.js"
    ),
    c4_component(
      "order_controller", "Order Controller",
      "Handles order processing requests", "Express.js"
    ),
    c4_component(
      "product_service", "Product Service",
      "Business logic for product management", "Node.js"
    ),
    c4_component(
      "order_service", "Order Service",
      "Business logic for order processing", "Node.js"
    ),
    c4_component(
      "database_client", "Database Client",
      "Handles database connections and queries", "Sequelize ORM"
    ),
    c4_component(
      "cache_client", "Cache Client",
      "Manages cache operations", "Redis Client"
    )
  ),

  # External systems this container interacts with
  external_system = list(
    c4_external_system("database", "PostgreSQL Database", "Main data store"),
    c4_external_system("cache", "Redis Cache", "Session and data cache"),
    c4_external_system("payment", "Payment Gateway", "Stripe API"),
    c4_external_system("email", "Email Service", "SendGrid API")
  ),

  # Component relationships
  relationships = list(
    # Controller to service relationships
    c4_rel("product_controller", "product_service", "Uses", "Method calls"),
    c4_rel("order_controller", "order_service", "Uses", "Method calls"),
    c4_rel("order_controller", "auth_controller", "Validates auth", "Method calls"),

    # Service to data access relationships
    c4_rel("product_service", "database_client", "Reads/writes product data", "SQL"),
    c4_rel("order_service", "database_client", "Reads/writes order data", "SQL"),
    c4_rel("product_service", "cache_client", "Caches product data", "Redis"),

    # External integrations
    c4_rel("database_client", "database", "Connects to", "SQL/TCP"),
    c4_rel("cache_client", "cache", "Connects to", "Redis Protocol"),
    c4_rel("order_service", "payment", "Processes payments", "REST API"),
    c4_rel("order_service", "email", "Sends confirmations", "REST API")
  )
)

component_diagram
```

### Component Design Guidelines

- Focus on a single container
- Group related functionality into components
- Show the internal architecture patterns (MVC, layered, etc.)
- Include key abstractions and interfaces
- Consider component responsibilities and boundaries

## Customizing Your Diagrams

### Using Different Themes

c4r includes several built-in themes:

``` r
# Default theme (blue tones)
default_diagram <- c4_context(
  title = "Default Theme",
  person = list(c4_person("user", "User", "System user")),
  system = list(c4_system("app", "Application", "Main system")),
  relationships = list(c4_rel("user", "app", "Uses")),
  theme = "default"
)

# Dark theme
dark_diagram <- c4_context(
  title = "Dark Theme",
  person = list(c4_person("user", "User", "System user")),
  system = list(c4_system("app", "Application", "Main system")),
  relationships = list(c4_rel("user", "app", "Uses")),
  theme = "dark"
)

# Blue theme
blue_diagram <- c4_context(
  title = "Blue Theme",
  person = list(c4_person("user", "User", "System user")),
  system = list(c4_system("app", "Application", "Main system")),
  relationships = list(c4_rel("user", "app", "Uses")),
  theme = "blue"
)
```

### Best Practices

1.  **Start High-Level**: Begin with System Context, then drill down
2.  **Keep It Simple**: Don’t try to show everything in one diagram
3.  **Use Consistent Naming**: Keep element names consistent across
    diagram levels
4.  **Focus on Communication**: Choose the right level of detail for
    your audience
5.  **Iterate**: Diagrams evolve with your understanding and system
    changes

## Integration with R Workflows

### In R Markdown Documents

c4r diagrams work seamlessly in R Markdown:

```` markdown
``` r
my_diagram <- c4_context(
  title = "My System Context",
  # ... diagram definition
)

my_diagram
```


```{=html}
<div class="grViz html-widget html-fill-item" id="htmlwidget-febe03efa1a2d8d52a86" style="width:700px;height:432.632880098888px;"></div>
<script type="application/json" data-for="htmlwidget-febe03efa1a2d8d52a86">{"x":{"diagram":"digraph {\n  graph [rankdir=TB, bgcolor=\"white\", fontname=\"Arial\"];\n  node [fontname=\"Arial\", fontsize=10];\n  edge [fontname=\"Arial\", fontsize=8];\n\n  label=\"My System Context\";\n  labelloc=t;\n  fontsize=16;\n\n\n\n\n\n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>
```
````

### In Shiny Applications

``` r
library(shiny)
library(c4r)

ui <- fluidPage(
  titlePanel("Architecture Diagrams"),
  DiagrammeR::grVizOutput("diagram")
)

server <- function(input, output) {
  output$diagram <- DiagrammeR::renderGrViz({
    c4_context(
      title = "Dynamic Architecture View",
      # ... your diagram definition
    )
  })
}

shinyApp(ui = ui, server = server)
```

## Advanced Usage

### Working with Large Systems

For complex systems, consider creating multiple focused diagrams:

- Separate context diagrams for different user journeys
- Multiple container diagrams for different subsystems  
- Component diagrams for each major container

### Documentation Strategy

1.  **Context diagrams** in stakeholder presentations
2.  **Container diagrams** in technical design documents
3.  **Component diagrams** in developer documentation
4.  Keep diagrams in version control alongside code
5.  Update diagrams when architecture changes

## Next Steps

- Explore the [function
  reference](https://fabiandistler.github.io/c4r/reference/index.md) for
  detailed API documentation
- Check out the
  [c4_demo()](https://fabiandistler.github.io/c4r/reference/c4_demo.md)
  function for more examples
- Learn more about the C4 model at [c4model.com](https://c4model.com/)
- Consider integrating c4r diagrams into your documentation workflow
