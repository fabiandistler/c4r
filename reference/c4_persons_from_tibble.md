# Create person elements from a tibble or data frame

Create person elements from a tibble or data frame

## Usage

``` r
c4_persons_from_tibble(data)
```

## Arguments

- data:

  A tibble or data frame with columns: id, label, description

## Value

A list of person elements

## Examples

``` r
if (FALSE) { # \dontrun{
library(tibble)
persons_df <- tribble(
  ~id,     ~label,    ~description,
  "user1", "User 1",  "First user",
  "user2", "User 2",  "Second user"
)
persons <- c4_persons_from_tibble(persons_df)
} # }
```
