skip_if_not_installed("withr")

write_pkg <- function(dir, imports = "cli", suggests = "testthat") {
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  desc_lines <- c(
    "Package: dummypkg",
    "Title: Dummy",
    "Version: 0.0.1",
    "Description: A dummy package.",
    "License: MIT + file LICENSE",
    "Encoding: UTF-8"
  )
  if (length(imports) > 0) desc_lines <- c(desc_lines, paste0("Imports: ", paste(imports, collapse = ", ")))
  if (length(suggests) > 0) desc_lines <- c(desc_lines, paste0("Suggests: ", paste(suggests, collapse = ", ")))
  writeLines(desc_lines, file.path(dir, "DESCRIPTION"))
  dir.create(file.path(dir, "R"), showWarnings = FALSE)
  writeLines("foo <- function() 1", file.path(dir, "R", "foo.R"))
  writeLines("bar <- function() 2", file.path(dir, "R", "bar.R"))
}

test_that("c4_from_package errors outside a package", {
  withr::with_tempdir({
    expect_error(c4_from_package("."), "DESCRIPTION")
  })
})

test_that("c4_from_package builds a context-level c4_builder", {
  withr::with_tempdir({
    write_pkg(".", imports = c("cli", "glue"), suggests = c("testthat"))
    b <- c4_from_package(".", level = "context")
    expect_s3_class(b, "c4_builder")
    expect_equal(length(b$systems), 1)
    expect_true("dummypkg" %in% vapply(b$systems, `[[`, character(1), "id"))
    ext_ids <- vapply(b$external_systems, `[[`, character(1), "id")
    expect_true(all(c("cli", "glue") %in% ext_ids))
    expect_true("testthat" %in% ext_ids)
  })
})

test_that("c4_from_package skips Suggests when include_suggests = FALSE", {
  withr::with_tempdir({
    write_pkg(".", imports = "cli", suggests = "testthat")
    b <- c4_from_package(".", include_suggests = FALSE)
    ext_ids <- vapply(b$external_systems, `[[`, character(1), "id")
    expect_false("testthat" %in% ext_ids)
  })
})

test_that("c4_from_package builds a container-level c4_builder", {
  withr::with_tempdir({
    write_pkg(".")
    b <- c4_from_package(".", level = "container")
    expect_s3_class(b, "c4_builder")
    container_ids <- vapply(b$containers, `[[`, character(1), "id")
    expect_true(all(c("foo", "bar") %in% container_ids))
  })
})

test_that("make_safe_id handles edge cases", {
  expect_equal(make_safe_id("dplyr"), "dplyr")
  expect_equal(make_safe_id("my.pkg"), "my_pkg")
  expect_equal(make_safe_id("123pkg"), "x_123pkg")
  expect_equal(make_safe_id(""), "x")
})
