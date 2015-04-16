#'@title classify the format of a package's name
#'@description package names come likethis and like.this
#'and Like.THIS and in a whole host of formats. \code{check_package_naming}
#'consumes package metadata and identifies the format a package's name follows,
#'using the convention described below.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}}
#'
#'@return a named, two-element list containing "casing" ("Lower", "Upper" or "Mixed")
#'and "alphanumeric" (TRUE for package names that exclusively contain alphanumeric characters,
#'and FALSE for package names that contain special characters.)
#'
#'@seealso
#'\code{\link{check_internal_naming}} for identifying if a consistent naming convention
#'is used for functions within the package, and if so, what it is.
#'@export
check_package_naming <- function(package_metadata){
  
  #Extract title, instantiate output object
  package_name <- package_metadata$name
  output <- list(casing = "Mixed", alphanumeric = TRUE)
  
  #Casing
  if(tolower(package_name) == package_name){
    output$casing <- "Lower"
  } else if(toupper(package_name) == package_name){
    output$casing <- "Upper"
  }
  
  #All-alphanumeric or not? This just means "does it have a period
  #in it" - I tested against all of CRAN to make sure.
  casing <- "Mixed Case"
  if(grepl(x = package_name, pattern = ".", fixed = TRUE)){
    casing <- FALSE
  }
  
  return(output)
}

check_internal_naming <- function(package_directory){
  
}