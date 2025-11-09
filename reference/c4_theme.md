# Create a custom C4 theme

Define custom colors for C4 diagram elements

## Usage

``` r
c4_theme(
  name = "custom",
  bg = "white",
  person = "#08427B",
  system = "#1168BD",
  container = "#438DD5",
  component = "#85BBF0",
  external_system = "#999999",
  edge = "#666666",
  group_border = "#CCCCCC"
)
```

## Arguments

- name:

  Theme name

- bg:

  Background color

- person:

  Person node color

- system:

  System node color

- container:

  Container node color

- component:

  Component node color

- external_system:

  External system node color

- edge:

  Edge/relationship color

- group_border:

  Group boundary color (optional)

## Value

A list representing a custom theme

## Examples

``` r
# Create a corporate theme
corp_theme <- c4_theme(
  name = "corporate",
  bg = "#FFFFFF",
  person = "#E74C3C",
  system = "#3498DB",
  container = "#2ECC71",
  component = "#F39C12",
  external_system = "#95A5A6",
  edge = "#34495E"
)
```
