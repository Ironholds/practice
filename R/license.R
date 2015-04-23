#'@title extract the licenses used by a package
#'@description when provided with package metadata, \code{get_license}
#'extracts each unique license a package is released under and provides
#'them as a vector.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}},
#'or the name of a package (in which case \code{get_package_metadata} will be called
#'internally).
#'
#'@details license information is not stored in a tremendously consistent way, but
#'we can make a best-guess at it by stripping out "+ file license" strings, and
#'then splitting on |.
#'
#'@return a character vector containing each unique license mentioned in the
#'package's DESCRIPTION field.
#'
#'@examples
#'
#'#What license(s) are urltools under?
#'get_license(get_package_metadata("urltools"))
#'
#'@seealso the package index for more checks and functionality.
#'
#'@export
get_license <- function(package_metadata){
  package_metadata <- check_metadata(package_metadata)
  license_info <- package_metadata$License
  license_info <- gsub(x = license_info, pattern = "(\\||\\+) file LICENSE", replacement = "")
  licenses <- unlist(strsplit(license_info, split = "|", fixed = TRUE))
  licenses <- gsub(x = licenses, pattern = "(^ | $)", replacement = "")
  return(licenses)
}