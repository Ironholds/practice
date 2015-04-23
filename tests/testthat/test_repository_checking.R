context("Repositories can be IDd")

# Create dummy metadata. all determines whether there should be
# "multiple versions"- all metadata checkers should work with
# either multiple-version metadata or single-version.
create_dummy <- function(..., all = FALSE) {
  ret <- list(...)
  if (all) {
    ret <- list(versions = list("1.0.0" = ret), latest = "1.0.0")
  }
  ret
}

test_that("GitHub links can be IDd", {
  for (all in c(TRUE, FALSE)) {
    dummy_obj <- create_dummy(URL = "http://github.com/foo", BugReports = "Blah", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "GitHub")
    dummy_obj <- create_dummy(URL = "http://GITHUB.COM/foo", BugReports = "Blah", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "GitHub")
    dummy_obj <- create_dummy(URL = "Blah", BugReports = "http://github.com/foo", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "GitHub")
  }
})

test_that("RForge links can be IDd", {
  for (all in c(TRUE, FALSE)) {
    dummy_obj <- create_dummy(URL = "http://r-forge.r-project.org/", BugReports = "Blah", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "R-Forge")
    dummy_obj <- create_dummy(URL = "http://R-Forge.r-project.org/", BugReports = "Blah", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "R-Forge")
    dummy_obj <- create_dummy(URL = "Blah", BugReports = "http://r-forge.r-project.org/", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "R-Forge")
  }
})

test_that("BitBucket links can be IDd", {
  for (all in c(TRUE, FALSE)) {
    dummy_obj <- create_dummy(URL = "https://bitbucket.org/halfak/wikimedia-utilities", BugReports = "Blah", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "BitBucket")
    dummy_obj <- create_dummy(URL = "https://BitBucket.org/halfak/wikimedia-utilities", BugReports = "Blah", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "BitBucket")
    dummy_obj <- create_dummy(URL = "Blah", BugReports = "https://bitbucket.org/halfak/wikimedia-utilities", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "BitBucket")
  }
})

test_that("Email addresses can be IDd", {
  for (all in c(TRUE, FALSE)) {
    dummy_obj <- create_dummy(URL = "foo.bar.baz", BugReports = "blargh@doover.org", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "Email")
    dummy_obj <- create_dummy(URL = "blargh@doover.org", BugReports = "foo.bar.baz", all = all)
    expect_equal(check_upstream_repository(dummy_obj), "Email")
  }
})
