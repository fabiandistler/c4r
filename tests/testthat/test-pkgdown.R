test_that("pkgdown_diagram sets width and height on htmlwidgets", {
  diagram <- c4_context(
    title = "T",
    person = list(c4_person("u", "U", "User")),
    system = list(c4_system("s", "S", "System")),
    relationships = list(c4_rel("u", "s", "Uses"))
  )
  out <- pkgdown_diagram(diagram, height = "600px", width = "80%")
  expect_equal(out$width, "80%")
  expect_equal(out$height, "600px")
  expect_equal(out$sizingPolicy$defaultHeight, "600px")
})

test_that("pkgdown_diagram rejects non-htmlwidget input", {
  expect_error(pkgdown_diagram(list()), "htmlwidget")
})
