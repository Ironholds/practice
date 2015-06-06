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
  expect_equal(names(metadata),
               c("Package", "Type", "Title", "Version", "Authors@R",
                 "Description", "Depends", "Imports", "Suggests",
                 "VignetteBuilder", "Enhances", "License", "URL",
                 "BugReports", "LazyData", "Collate", "Packaged",
                 "Author", "Maintainer", "NeedsCompilation", "Repository",
                 "Date/Publication", "crandb_file_date", "date",
                 "releases", "retrieved"))

  metadata <- get_package_metadata("ggplot2", "all")
  expect_true(is.list(metadata))
  expect_equal(names(metadata),
               c("_id", "_rev", "name", "versions", "timeline", "latest",
                 "title", "archived", "revdeps", "retrieved"))

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
