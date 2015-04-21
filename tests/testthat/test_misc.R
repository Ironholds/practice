context("Test miscellaneous functionality (license identification, links)")

test_that("Licenses can be extracted and identified",{
  expect_that(get_license("A3"), equals("GPL (>= 2)"))
})

test_that("Multi-license packages can be interpreted correctly", {
  result <- get_license("MASS")
  expect_that(length(result), equals(2))
  expect_that(is.vector(result,"character"), equals(TRUE))
  expect_that(result, equals(c("GPL-2","GPL-3")))
})

test_that("links_to works with with_versions=FALSE",{
  result <- links_to("urltools")
  expect_that(length(result), equals(3))
  expect_that(is.vector(result,"character"), equals(TRUE))
})

test_that("links_to works with with_versions=TRUE",{
  result <- links_to("urltools", with_versions=TRUE)
  expect_that(nrow(result), equals(3))
  expect_that(names(result), equals(c("package","version")))
})

test_that("links_from works",{
  result <- links_from("ggplot2")
  expect_that(length(result), equals(1))
  expect_that(is.vector(result,"integer"), equals(TRUE))
})