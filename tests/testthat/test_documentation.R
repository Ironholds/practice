context("Test that vignette, roxygen2 and changelog identification works")

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