# Modify an existing C4 theme

Create a new theme based on an existing one with some colors changed

## Usage

``` r
c4_modify_theme(base_theme, ...)
```

## Arguments

- base_theme:

  Base theme name ("default", "dark", "blue") or a c4_theme object

- ...:

  Named color parameters to override

## Value

A modified theme object

## Examples

``` r
# Modify the dark theme
my_theme <- c4_modify_theme("dark",
  system = "#1E3A8A",
  edge = "#60A5FA"
)
```
