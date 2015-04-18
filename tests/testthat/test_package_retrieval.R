context("Test that package names, metadata and content can be retrieved")

test_that("Package names can be retrieved", {
  package_names <- get_package_names()
  expect_true(is.vector(package_names, "character"))
})

test_that("Package metadata can be retrieved", {
  metadata <- get_package_metadata("ggplot2")
  expect_true(is.list(metadata))
  expect_that(names(metadata), equals(c("_id","_rev","name","versions","timeline","latest","title","archived", "revdeps")))
})

test_that("Package content can be retrieved", {
  result <<- get_package_source("ggplot2")
  expect_true(is.vector(result, "character"))
  expect_that(length(result), equals(1))
})

test_that("Package content can be deleted", {
  remove_package_source(result)
})