#'@title extract the licenses used by a package
#'@description when provided with package metadata, \code{get_license}
#'extracts each unique license a package is released under and provides
#'them as a vector.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}},
#'or the name of a package (in which case \code{get_package_metadata} will be called
#'internally).
#'
#'@return a character vector containing each unique license mentioned in the
#'package's DESCRIPTION field.
#'
#'@examples
#'\dontrun{
#'#What license(s) are urltools under?
#'get_license(get_package_metadata("urltools"))
#'}
#'
#'@export
get_license <- function(package_metadata){
  package_metadata <- check_metadata(package_metadata)
  license_info <- package_metadata$versions[[length(package_metadata$versions)]]$License
  license_info <- gsub(x = license_info, pattern = "(\\||\\+) file LICENSE", replacement = "")
  licenses <- unlist(strsplit(license_info, split = "|", fixed = TRUE))
  return(licenses)
}