# c4r

c4r provides a simple R interface for creating C4 architecture diagrams.
The package focuses on the first three levels of the C4 model (Context,
Container, Component), generating diagrams using Graphviz DOT notation
rendered through {DiagrammeR}. For the Code level, consider the
[{flow}](https://github.com/moodymudskipper/flow) package.

## Installation

c4r is not yet available on CRAN. You can install the development
version from GitHub:

``` r
# install.packages("pak")
pak::pak("fabiandistler/c4r")
```

## Quick Example

``` r
library(c4r)

# Create a simple system context diagram
c4_context(
  title = "My System Context",
  person = list(c4_person("user", "User", "System user")),
  system = list(c4_system("app", "My App", "Does something useful")),
  relationships = list(c4_rel("user", "app", "Uses"))
)
```

## Learn More

- **[Getting Started
  Guide](https://fabiandistler.github.io/c4r/articles/getting-started.html)** -
  Complete tutorial with examples
- **[Function
  Reference](https://fabiandistler.github.io/c4r/reference/)** - API
  documentation
