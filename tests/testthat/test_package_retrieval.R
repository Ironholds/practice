context("Test that package names, metadata and content can be retrieved")
local({
  repos <- getOption("repos")
  repos["CRAN"] <- "http://cran.rstudio.com"
  options(repos = repos)
})


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
  result <- get_package_source("A3")
  expect_true(is.vector(result, "character"))
  expect_that(length(result), equals(1))
  remove_package_source(result)
  
})

test_that("Package content can be deleted", {
  result <- get_package_source("A3")
  remove_package_source(result)
  expect_that(file.exists(result), equals(FALSE))
})