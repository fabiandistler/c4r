test_that("c4_person creates valid person element", {
  person <- c4_person("user1", "User", "A system user")

  expect_type(person, "list")
  expect_equal(person$id, "user1")
  expect_equal(person$label, "User")
  expect_equal(person$description, "A system user")
})

test_that("c4_person handles default values", {
  person <- c4_person("user1")

  expect_equal(person$id, "user1")
  expect_equal(person$label, "user1")
  expect_equal(person$description, "")
})

test_that("c4_system creates valid system element", {
  system <- c4_system("sys1", "System", "A software system", "Java")

  expect_type(system, "list")
  expect_equal(system$id, "sys1")
  expect_equal(system$label, "System")
  expect_equal(system$description, "A software system")
  expect_equal(system$technology, "Java")
})

test_that("c4_rel creates valid relationship", {
  rel <- c4_rel("user1", "sys1", "Uses", "HTTPS")

  expect_type(rel, "list")
  expect_equal(rel$from, "user1")
  expect_equal(rel$to, "sys1")
  expect_equal(rel$label, "Uses")
  expect_equal(rel$technology, "HTTPS")
})

test_that("constructor functions validate inputs", {
  expect_error(c4_person(123), "must be a single character string")
  expect_error(c4_system(c("a", "b")), "must be a single character string")
  expect_error(c4_rel("a", 123, "label"), "must be a single character string")
})
