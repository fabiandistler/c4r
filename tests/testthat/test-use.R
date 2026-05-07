skip_if_not_installed("withr")

create_dummy_pkg <- function(dir) {
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  writeLines(
    c(
      "Package: dummypkg",
      "Title: Dummy",
      "Version: 0.0.1",
      "Description: A dummy package for tests.",
      "License: MIT + file LICENSE",
      "Encoding: UTF-8",
      "Imports: cli, glue",
      "Suggests: testthat"
    ),
    file.path(dir, "DESCRIPTION")
  )
  dir.create(file.path(dir, "R"), showWarnings = FALSE)
  writeLines("dummy <- function() invisible(NULL)", file.path(dir, "R", "dummy.R"))
}

test_that("check_pkg_root errors outside a package", {
  withr::with_tempdir({
    expect_error(check_pkg_root("."), "DESCRIPTION")
  })
})

test_that("use_c4r_vignette writes a vignette", {
  withr::with_tempdir({
    create_dummy_pkg(".")
    out <- use_c4r_vignette(".", template = "monolith")
    expect_true(file.exists(out))
    contents <- readLines(out)
    expect_true(any(grepl("monolith", contents, fixed = TRUE)))
    # Vignettes knit with wd = vignettes/, so the template must reach the
    # package root via ".." rather than ".". Regression guard for #12.
    expect_true(any(grepl('c4_from_package("..")', contents, fixed = TRUE)))
    expect_false(any(grepl('c4_from_package(".")', contents, fixed = TRUE)))
  })
})

test_that("use_c4r_vignette respects overwrite flag", {
  withr::with_tempdir({
    create_dummy_pkg(".")
    out <- use_c4r_vignette(".", template = "monolith")
    mtime1 <- file.info(out)$mtime
    Sys.sleep(1)
    use_c4r_vignette(".", template = "serverless")
    expect_false(any(grepl("serverless", readLines(out), fixed = TRUE)))
    use_c4r_vignette(".", template = "serverless", overwrite = TRUE)
    expect_true(any(grepl("serverless", readLines(out), fixed = TRUE)))
  })
})

test_that("use_c4r_pkgdown idempotently adds an Architecture entry", {
  skip_if_not_installed("yaml")
  withr::with_tempdir({
    create_dummy_pkg(".")
    yaml::write_yaml(list(url = "https://example.com", articles = list()), "_pkgdown.yml")
    use_c4r_pkgdown(".")
    yml <- yaml::read_yaml("_pkgdown.yml")
    expect_true(any(vapply(yml$articles, function(a) isTRUE(a$title == "Architecture"), logical(1))))
    # Second call should not duplicate
    use_c4r_pkgdown(".")
    yml2 <- yaml::read_yaml("_pkgdown.yml")
    arch_entries <- sum(vapply(yml2$articles, function(a) isTRUE(a$title == "Architecture"), logical(1)))
    expect_equal(arch_entries, 1)
  })
})

test_that("use_c4r_action copies the workflow file", {
  withr::with_tempdir({
    create_dummy_pkg(".")
    out <- use_c4r_action(".")
    expect_true(file.exists(out))
    expect_true(any(grepl("c4r", readLines(out), fixed = TRUE)))
  })
})

test_that("use_c4r_readme creates README.Rmd if missing", {
  withr::with_tempdir({
    create_dummy_pkg(".")
    out <- use_c4r_readme(".")
    expect_true(file.exists(out))
    contents <- readLines(out)
    expect_true(any(grepl("c4r::", contents, fixed = TRUE)))
    expect_true(any(grepl("always_allow_html: true", contents, fixed = TRUE)))
    expect_true(any(grepl("knitr::include_graphics", contents, fixed = TRUE)))
  })
})
