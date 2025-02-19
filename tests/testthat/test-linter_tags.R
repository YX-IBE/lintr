test_that("available_linters returns a data frame", {
  avail <- available_linters()
  avail2 <- available_linters(c("lintr", "not-a-package"))
  empty <- available_linters("not-a-package")

  expect_s3_class(avail, "data.frame")
  expect_identical(avail, avail2)
  expect_identical(nrow(empty), 0L)
  expect_named(avail, c("linter", "package", "tags"))
  expect_type(avail[["linter"]], "character")
  expect_type(avail[["package"]], "character")
  expect_type(avail[["tags"]], "list")
  expect_type(avail[["tags"]][[1L]], "character")
})

test_that("default_linters and default tag match up", {
  avail <- available_linters()
  tagged_default <- avail[["linter"]][vapply(avail[["tags"]], function(tags) "default" %in% tags, logical(1L))]
  expect_setequal(tagged_default, names(default_linters))
})

test_that("available_linters matches the set of linters available from lintr", {
  lintr_db <- available_linters()
  all_linters <- ls(asNamespace("lintr"), pattern = "_linter$")
  # ensure that the contents of inst/lintr/linters.csv covers all _linter objects in our namespace
  expect_setequal(lintr_db$linter, all_linters)
  # ensure that all _linter objects in our namespace are also exported
  expect_setequal(all_linters, grep("_linter$", getNamespaceExports("lintr"), value = TRUE))
})
