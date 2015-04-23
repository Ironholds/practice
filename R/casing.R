#'@title classify the format of a package's name
#'@description package names come likethis and like.this
#'and Like.THIS and in a whole host of formats. \code{check_package_naming}
#'consumes package metadata and identifies the format a package's name follows,
#'using the convention described below.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}},
#'or the name of a package (in which case \code{get_package_metadata} will be called
#'internally).
#'
#'@return a named, two-element list containing "casing" ("Lower", "Upper" or "Mixed")
#'and "alphanumeric" (TRUE for package names that exclusively contain alphanumeric characters,
#'and FALSE for package names that contain special characters.)
#'
#'@examples
#'#Identify if dplyr is all lower-case (yep) and only contains alphanumeric characters
#'#(also yep)
#'check_package_naming(get_package_metadata("ggplot2"))
#'
#'#gridExtra, not so much
#'check_package_naming(get_package_metadata("gridExtra"))
#'
#'@export
check_package_naming <- function(package_metadata){
  
  #Check, extract title, instantiate output object
  package_metadata <- check_metadata(package_metadata)
  package_name <- package_metadata$Package
  output <- list(casing = "Mixed", alphanumeric = TRUE)
  
  #Casing
  if(tolower(package_name) == package_name){
    output$casing <- "Lower"
  } else if(toupper(package_name) == package_name){
    output$casing <- "Upper"
  }
  
  #All-alphanumeric or not? This just means "does it have a period
  #in it" - I tested against all of CRAN to make sure.
  if(grepl(x = package_name, pattern = ".", fixed = TRUE)){
    alphanumeric <- FALSE
  }
  
  return(output)
}