test_that("create_c4_nodes handles empty inputs", {
  nodes <- create_c4_nodes(list(), list(), list(), "context")
  
  expect_s3_class(nodes, "data.frame")
  expect_equal(nrow(nodes), 0)
  expect_true(all(c("id", "label", "type", "description", "technology") %in% names(nodes)))
})

test_that("create_c4_nodes creates person nodes correctly", {
  person <- list(c4_person("user1", "User", "A user"))
  nodes <- create_c4_nodes(person, list(), list(), "context")
  
  expect_equal(nrow(nodes), 1)
  expect_equal(nodes$id[1], "user1")
  expect_equal(nodes$type[1], "person")
  expect_equal(nodes$label[1], "User")
})

test_that("create_c4_edges handles empty relationships", {
  edges <- create_c4_edges(list())
  
  expect_s3_class(edges, "data.frame")
  expect_equal(nrow(edges), 0)
  expect_true(all(c("from", "to", "label", "technology") %in% names(edges)))
})

test_that("create_c4_edges creates edges correctly", {
  rel <- list(c4_rel("user1", "sys1", "Uses"))
  edges <- create_c4_edges(rel)
  
  expect_equal(nrow(edges), 1)
  expect_equal(edges$from[1], "user1")
  expect_equal(edges$to[1], "sys1")
  expect_equal(edges$label[1], "Uses")
})

test_that("generate_c4_dot creates valid DOT notation", {
  nodes <- data.frame(
    id = "user1",
    label = "User",
    type = "person",
    description = "A user",
    technology = "",
    stringsAsFactors = FALSE
  )
  
  edges <- data.frame(
    from = character(0),
    to = character(0),
    label = character(0),
    technology = character(0),
    stringsAsFactors = FALSE
  )
  
  dot <- generate_c4_dot("Test Diagram", nodes, edges, "default", "context")
  
  expect_type(dot, "character")
  expect_true(grepl("digraph", dot))
  expect_true(grepl("Test Diagram", dot))
  expect_true(grepl("user1", dot))
})