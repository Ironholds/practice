context("Test miscellaneous functionality (license identification, say)")

test_that("Licenses can be extracted and identified",{
  expect_that(get_license("A3"), equals("GPL (>= 2)"))
})

test_that("Multi-license packages can be interpreted correctly", {
  result <- get_license("MASS")
  expect_that(length(result), equals(2))
  expect_that(is.vector(result,"character"), equals(TRUE))
  expect_that(result, equals(c("GPL-2","GPL-3")))
})