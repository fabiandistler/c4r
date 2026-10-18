# Architecture

This page renders a C4 diagram of the package architecture using
[c4r](https://fabiandistler.github.io/c4r/).

## From package metadata

``` r

c4r::c4_from_package("..") |> c4r::build_context()
```

## From a starter template

``` r

c4r::c4_from_template("three_tier")
```

## As a declarative chunk

The `c4` knitr engine lets you describe a diagram in a small DSL:
