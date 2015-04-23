#'@title identify a package's unit testing framework, if it has one
#'@description takes a downloaded package and identifies if the package
#'has a unit testing framework, or anything indicative of automated testing.
#'
#'@param package_directory the full path to the directory, retrieved
#'with \code{\link{get_package_source}}.
#'
#'@details identifying if a package has unit tests (and what form
#'those tests take) is a pain because the frameworks can be stored
#'in a lot of different ways.
#'RUnit can exist in a dedicated "tests" directory, or embedded in
#'the actual package's R code. testthat tends to standardise on a
#'"test" directory. And, of course, informal tests outside of these
#'frameworks can look like pretty much anything.
#'
#'\code{check_testing} hunts through the .R files in a package
#'for calls to load RUnit; if some are found, the tests are RUnit-based.
#'The same test with "testthat" is used to determine if tests are
#'testthat-based - and if neither are found, the presence of a top-level
#'directory called "tests" leads to "Other".
#'
#'@return either "None" (no recogniseable tests), "RUnit" (RUnit-based
#'tests), "testthat" (testthat-based tests) or "Other" (some form
#'of hand-rolled testing).
#'
#'@examples
#'\dontrun{
#'#urltools uses testthat
#'file_location <- get_package_source("urltools")
#'check_testing(file_location)
#'
#'#blme uses RUnit
#'file_location <- get_package_source("blme")
#'check_testing(file_location)
#'
#'#fortunes has no tests.
#'file_location <- get_package_source("fortunes")
#'check_testing(file_location)
#'}
#'
#'@seealso \code{\link{check_upstream_repository}}
#'to identify if a package has an upstream source anywhere
#'(GitHub, BitBucket) that users can use to provide patches and/or
#'bug reports, and the package index for more checks.
#'
#'@export
check_testing <- function(package_directory){
  test_dir <- file.path(package_directory, "tests")
  inst_dir <- file.path(package_directory, "inst")
  desc_file <- file.path(package_directory, "DESCRIPTION")

  #Check for RUnit, testthat first
  runit_str <- "((library|require)\\(RUnit\\)|RUnit::)"
  testthat_str <- "((library|require)\\(testthat\\)|testthat::)"
  if (file.exists(desc_file) && check_file(desc_file, "RUnit")) {
    return("RUnit")
  }
  if (check_content(test_dir, runit_str) ||
      check_content(inst_dir, runit_str)) {
    return("RUnit")
  }
  if (file.exists(desc_file) && check_file(desc_file, "testthat")) {
    return("testthat")
  }
  if (check_content(test_dir, testthat_str) ||
      check_content(inst_dir, testthat_str)) {
    return("testthat")
  }
  if (file.exists(test_dir)) {
    return("Other")
  }
  
  return("None")
}

#'@title identify if a package is semantically versioned
#'@description take a package's metadata and identify
#'from it whether the package follows the "semantic versioning"
#'convention, at least in theory. See details for, well,
#'details.
#'
#'@details \href{http://semver.org/}{semantic versioning}
#'is a convention for identifying version numbers of a codebase
#'in a way that distinguishes major changes, minor changes
#'and patches by using three period-separated
#'groups of digits. As an example, 2.0.0 is semantically
#'versioned; 2.0 is not.
#'
#'\code{check_versioning} takes the latest package version
#'number found in package_metadata and identifies whether
#'it follows this format (TRUE) or does not (FALSE).
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}},
#'or the name of a package (in which case \code{get_package_metadata} will be called
#'internally).
#'
#'@return TRUE if the package does follow the semantic versioning standard,
#'FALSE if not.
#'
#'@examples
#'#Identify if ggplot2 is semantically versioned (it is)
#'ggplot_metadata <- get_package_metadata("ggplot2")
#'check_versioning(ggplot_metadata)
#'
#'#Identify if fbRanks is semantically versioned (it isn't)
#'fbranks_metadata <- get_package_metadata("fbRanks")
#'check_versioning(fbranks_metadata)
#'
#'@seealso
#'\code{\link{check_vignettes}} to identify if a package has vignettes
#'and how they are built, \code{\link{check_roxygen}} to see if inline
#'documentation is built with roxygen2, and the package index for more
#'tests and checks.
#'
#'@export
check_versioning <- function(package_metadata){
  latest_version <- check_metadata(package_metadata)
  return(grepl(x = latest_version$Version, pattern = "\\d{1,}\\.\\d{1,}\\.\\d{1,}"))
}

#'@title identifies if a package indicates it has a versioned repository for
#'upstream patches or bug reports.
#'
#'@description A crucial element of good software is software that users can patch
#'(or at least complain about). \code{check_upstream_repository} consumes package
#'metadata and identifies from it if users are provided with an actual versioning
#'system, or contact email, to forward issues or fixes to.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}},
#'or the name of a package (in which case \code{get_package_metadata} will be called
#'internally).
#'
#'
#'@details
#'\code{check_upstream_repository} works by checking the "URL" and "BugReports"
#'fields of the most recent package release - since these are the fields most likely
#'to contain a valid pointer to an upstream source - for anything that case-insensitively
#'matches "github", "r-forge", "bitbucket" or "@@" (for email addresses). If one is matched,
#'that's the value. If none are matched, "None/Other".
#'
#'@return "GitHub", "R-Forge", "BitBucket", "Email" or "None/Other".
#'
#'@examples
#'\dontrun{
#'#urltools uses GitHub. Let's see if we can identify that.
#'urltools_metadata <- get_package_metadata("urltools")
#'check_upstream_repository(urltools_metadata)
#'
#'#tm uses R-Forge
#'tm_metadata <- get_package_metadata("tm")
#'check_upstream_repository(tm_metadata)
#'}
#'
#'@seealso see the package index for more checks.
#'@export
check_upstream_repository <- function(package_metadata){
  
  #Get last release and stick the fields that could plausibly contain a repo location
  #in an atomic vector.
  last_release <- check_metadata(package_metadata)
  possible_repositories <- c(last_release$URL, last_release$BugReports)
  
  #Iterate through seeing if the fields contain anything we recognise. If they don't
  #the default of "no repository/repository we don't know" is held.
  repository <- "None/Other"
  if(any(grepl(x = possible_repositories, pattern = "github", ignore.case = TRUE))){
    repository <- "GitHub"
  } else if(any(grepl(x = possible_repositories, pattern = "r-forge", ignore.case = TRUE))){
    repository <- "R-Forge"
  } else if(any(grepl(x = possible_repositories, pattern = "bitbucket", ignore.case = TRUE))){
    repository <- "BitBucket"
  } else if(any(grepl(x = possible_repositories, pattern = "@"))){
    repository <- "Email"
  }
  return(repository)
}