check_testing <- function(package_directory){
  
}

#'Internal function specifically for checking for runit
check_runit <- function(package_directory){
  
}

#Internal function for testthat. This is easier logic.
check_testthat <- function(package_directory){
  
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