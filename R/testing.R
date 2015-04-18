#'@title identify a package's unit testing framework, if it has one
#'@description takes a downloaded package and identifies if the package
#'has a unit testing framework, or anything indicative of automated testing.
#'
#'@param package_directory the full path to the directory, retrieved
#'with \code{\link{get_package_source}}.
#'
#'@return either "None" (no recogniseable tests), "RUnit" (RUnit-based
#'tests), "testthat" (testthat-based tests) or "Other" (some form
#'of hand-rolled testing).
#'
#'@export
check_testing <- function(package_directory){
  
  output <- "None"
  
  #Check for RUnit, testthat first
  if(check_content(package_directory, "((library|require)\\(RUnit\\)|RUnit::)")){
    output <- "RUnit"
  } else if(check_content(package_directory, "((library|require)\\(testthat\\)|testthat::)")){
    output <- "testthat"
  } else if(grepl(x = list.files(), pattern = "tests", fixed = TRUE)){
    output <- "Other"
  }
  return(output)
}

#'@title identifies if a package indicates it has a versioned repository for
#'upstream patches or bug reports.
#'@description A crucial element of good software is software that users can patch
#'(or at least complain about). \code{check_upstream_repository} consumes package
#'metadata and identifies from it if users are provided with an actual versioning
#'system, or contact email, to forward issues or fixes to.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}}
#'
#'@return "GitHub", "R-Forge", "BitBucket", "Email" or "None/Other".
#'
#'@export
check_upstream_repository <- function(package_metadata){
  
  #Get last release and stick the fields that could plausibly contain a repo location
  #in an atomic vector.
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