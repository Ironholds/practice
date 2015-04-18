library(testthat)
library(practice)

#Set repo, since this isn't done by default and get_* tests will otherwise fail.
local({
  repos <- getOption("repos")
  repos["CRAN"] <- "http://cran.rstudio.com"
  options(repos = repos)
})
test_check("practice")
