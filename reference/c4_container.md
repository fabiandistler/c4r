# Create a container element for C4 diagrams

Create a container element for C4 diagrams

## Usage

``` r
c4_container(id, label = id, description = "", technology = "")
```

## Arguments

- id:

  Unique identifier for the container

- label:

  Display label for the container

- description:

  Optional description of the container

- technology:

  Optional technology information

## Value

A list representing a container element

## Examples

``` r
db <- c4_container("db", "Database", "Stores user data", "PostgreSQL")
```
