check_vignettes <- function(package_directory){
  
}

#'@title check whether a package's documentation uses roxygen2
#'@description identifies if a package's documentation uses
#'roxygen2's inline documentation, by scanning the R files
#'hunting for roxygen2 tags.
#'
#'@param package_directory the full path to the directory, retrieved
#'with \code{\link{get_package_source}}.
#'
#'@export
check_roxygen <- function(package_directory){
  check_content(package_directory, "@export")
}