context("Test that vignette, roxygen2 and changelog identification works")
local({
  repos <- getOption("repos")
  repos["CRAN"] <- "http://cran.rstudio.com"
  options(repos = repos)
})

test_that("Packages with roxygen2 documentation are identified as such",{
  file_location <- get_package_source("ggplot2")
  result <- check_roxygen(file_location)
  remove_package_source(file_location)
  expect_that(result, equals(TRUE))
})

test_that("Packages without roxygen2 documentation are identified as such",{
  file_location <- get_package_source("data.table")
  result <- check_roxygen(file_location)
  remove_package_source(file_location)
  expect_that(result, equals(FALSE))
})

test_that("Semantically versioned packages are identified as such",{
  metadata <- get_package_metadata("A3")
  expect_that(check_versioning(metadata), equals(TRUE))
})

test_that("Non-semantically versioned packages are identified as such",{
  metadata <- get_package_metadata("fbRanks")
  expect_that(check_versioning(metadata), equals(FALSE))
})

test_that("Packages with Knitr-built vignettes are identified",{
  file_location <- get_package_source("urltools")
  result <- check_vignettes(file_location)
  remove_package_source(file_location)
  expect_that(result$Builder, equals("knitr"))
  expect_that(result$Format, equals("Markdown"))
})

test_that("Packages with Sweave-built vignettes are identified",{
  file_location <- get_package_source("fortunes")
  result <- check_vignettes(file_location)
  remove_package_source(file_location)
  expect_that(result$Builder, equals("Sweave"))
  expect_that(result$Format, equals("LaTeX"))
})

test_that("Packages with no vignettes are identified",{
  file_location <- get_package_source("A3")
  result <- check_vignettes(file_location)
  remove_package_source(file_location)
  expect_that(result$Builder, equals("None"))
  expect_that(result$Format, equals("None"))
})

test_that("Packages with changelogs are identified",{
  file_location <- get_package_source("A3")
  result <- check_changelog(file_location)
  remove_package_source(file_location)
  expect_that(result, equals(TRUE))
})

test_that("Packages without changelogs are identified",{
  file_location <- get_package_source("fortunes")
  result <- check_changelog(file_location)
  remove_package_source(file_location)
  expect_that(result, equals(FALSE))
})