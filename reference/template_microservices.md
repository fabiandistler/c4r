# Microservices template

Microservices template

## Usage

``` r
template_microservices(
  services = c("service1", "service2"),
  databases = c("postgres"),
  message_queue = NULL,
  api_gateway = TRUE,
  title = "Microservices Architecture"
)
```

## Arguments

- services:

  Character vector of service names

- databases:

  Character vector of database names

- message_queue:

  Message queue type (optional)

- api_gateway:

  Include API gateway

- title:

  Diagram title
