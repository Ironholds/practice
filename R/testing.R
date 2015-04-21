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
  
  output <- "None"
  
  #Check for RUnit, testthat first
  if(check_content(package_directory, "((library|require)\\(RUnit\\)|RUnit::)")){
    output <- "RUnit"
  } else if(check_content(package_directory, "((library|require)\\(testthat\\)|testthat::)")){
    output <- "testthat"
  } else if(length(list.dirs(path = package_directory, full.names = FALSE, recursive = FALSE))){
    output <- "Other"
  }
  return(output)
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
  package_metadata <- check_metadata(package_metadata)
  last_release <- package_metadata$versions[[length(package_metadata$versions)]]
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