test_that("check_string validates input correctly", {
  expect_silent(check_string("valid"))
  expect_error(check_string(123), "must be a single character string")
  expect_error(check_string(c("a", "b")), "must be a single character string")
  expect_error(check_string(NULL), "must be a single character string")
})

test_that("check_list validates input correctly", {
  expect_silent(check_list(list(a = 1)))
  expect_silent(check_list(list()))
  expect_error(check_list("not a list"), "must be a list")
  expect_error(check_list(123), "must be a list")
})

test_that("check_theme validates themes correctly", {
  expect_silent(check_theme("default"))
  expect_silent(check_theme("dark"))
  expect_silent(check_theme("blue"))
  expect_error(check_theme("invalid"), "must be one of")
  expect_error(check_theme(123), "must be a single character string")
})

test_that("null coalescing operator works correctly", {
  expect_equal("a" %||% "b", "a")
  expect_equal(NULL %||% "b", "b")
  expect_equal("" %||% "b", "b")
  expect_equal(character(0) %||% "b", "b")
})

test_that("escape_dot_string escapes quotes", {
  expect_equal(escape_dot_string('test "quoted" string'), 'test \\"quoted\\" string')
  expect_equal(escape_dot_string("no quotes"), "no quotes")
})

test_that("get_c4_theme returns valid themes", {
  default_theme <- get_c4_theme("default")
  expect_type(default_theme, "list")
  expect_true(all(c("bg", "person", "system", "edge") %in% names(default_theme)))

  dark_theme <- get_c4_theme("dark")
  expect_type(dark_theme, "list")
  expect_true(all(c("bg", "person", "system", "edge") %in% names(dark_theme)))

  # Invalid theme should return default
  invalid_theme <- get_c4_theme("invalid")
  expect_equal(invalid_theme, default_theme)
})
