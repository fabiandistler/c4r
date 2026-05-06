test_that("parse_c4_dsl handles persons, systems, and rels", {
  body <- paste(
    "person: user \"End User\" \"A user\"",
    "system: api \"API\" \"REST endpoint\" [Service]",
    "rel: user -> api \"Uses\" [HTTPS]",
    sep = "\n"
  )
  parsed <- parse_c4_dsl(body)
  expect_length(parsed$persons, 1)
  expect_equal(parsed$persons[[1]]$id, "user")
  expect_equal(parsed$persons[[1]]$label, "End User")
  expect_length(parsed$systems, 1)
  expect_equal(parsed$systems[[1]]$technology, "Service")
  expect_length(parsed$relationships, 1)
  expect_equal(parsed$relationships[[1]]$from, "user")
  expect_equal(parsed$relationships[[1]]$to, "api")
  expect_equal(parsed$relationships[[1]]$technology, "HTTPS")
})

test_that("parse_c4_dsl ignores comments and blank lines", {
  body <- "\n# a comment\nperson: user\n\n"
  parsed <- parse_c4_dsl(body)
  expect_length(parsed$persons, 1)
})

test_that("parse_c4_dsl warns on unknown kinds", {
  expect_warning(parse_c4_dsl("nope: bad"), "Unknown")
})

test_that("c4_render_dsl produces an htmlwidget for context type", {
  body <- "person: user \"User\"\nsystem: app \"App\"\nrel: user -> app \"Uses\""
  out <- c4_render_dsl(body, type = "context", title = "Test")
  expect_true(inherits(out, "htmlwidget"))
})

test_that("c4_render_dsl errors on unknown type", {
  expect_error(c4_render_dsl("person: user", type = "bogus"), "Unknown")
})
