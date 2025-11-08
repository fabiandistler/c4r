#!/usr/bin/env Rscript
# Generate roxygen2 documentation
# Run this script to update all .Rd files in the man/ directory

if (!requireNamespace("roxygen2", quietly = TRUE)) {
  message("Installing roxygen2...")
  install.packages("roxygen2")
}

message("Generating documentation...")
roxygen2::roxygenise()
message("Documentation generated successfully!")
message("Please commit the changes to the man/ directory and NAMESPACE file.")
