context("Repositories can be IDd")

test_that("GitHub links can be IDd", {
  dummy_obj <- list(versions = list(list(URL = "http://github.com/foo", BugReports = "Blah")))
  expect_equal(check_upstream_repository(dummy_obj), "GitHub")
  dummy_obj <- list(versions = list(list(URL = "http://GITHUB.COM/foo", BugReports = "Blah")))
  expect_equal(check_upstream_repository(dummy_obj), "GitHub")
  dummy_obj <- list(versions = list(list(URL = "Blah", BugReports = "http://github.com/foo")))
  expect_equal(check_upstream_repository(dummy_obj), "GitHub")
})

test_that("RForge links can be IDd", {
  dummy_obj <- list(versions = list(list(URL = "http://r-forge.r-project.org/", BugReports = "Blah")))
  expect_equal(check_upstream_repository(dummy_obj), "R-Forge")
  dummy_obj <- list(versions = list(list(URL = "http://R-Forge.r-project.org/", BugReports = "Blah")))
  expect_equal(check_upstream_repository(dummy_obj), "R-Forge")
  dummy_obj <- list(versions = list(list(URL = "Blah", BugReports = "http://r-forge.r-project.org/")))
  expect_equal(check_upstream_repository(dummy_obj), "R-Forge")
})

test_that("BitBucket links can be IDd", {
  dummy_obj <- list(versions = list(list(URL = "https://bitbucket.org/halfak/wikimedia-utilities", BugReports = "Blah")))
  expect_equal(check_upstream_repository(dummy_obj), "BitBucket")
  dummy_obj <- list(versions = list(list(URL = "https://BitBucket.org/halfak/wikimedia-utilities", BugReports = "Blah")))
  expect_equal(check_upstream_repository(dummy_obj), "BitBucket")
  dummy_obj <- list(versions = list(list(URL = "Blah", BugReports = "https://bitbucket.org/halfak/wikimedia-utilities")))
  expect_equal(check_upstream_repository(dummy_obj), "BitBucket")
})

test_that("Email addresses can be IDd", {
  dummy_obj <- list(versions = list(list(URL = "foo.bar.baz", BugReports = "blargh@doover.org")))
  expect_equal(check_upstream_repository(dummy_obj), "Email")
  dummy_obj <- list(versions = list(list(URL = "blargh@doover.org", BugReports = "foo.bar.baz")))
  expect_equal(check_upstream_repository(dummy_obj), "Email")

})
