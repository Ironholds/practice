parse_practice_date <- function(dates){
  as.Date(strptime(substr(dates, 0, 19), "%Y-%m-%dT%H:%M:%S", tz = "UTC"))
}

#'@title Identify the Date of the Latest Release
#'@description Takes package metadata obtained with \code{\link{get_package_metadata}}
#'and returns a date object containing the date of the most recent package release.
#'
#'@param metadata a metadata object returned from \code{\link{get_package_metadata}}
#'
#'@examples
#'\dontrun{
#'package_metadata <- get_package_metadata("abf2")
#'latest_release(package_metadata)
#'}
#'@export
latest_release <- function(metadata){
  max(parse_practice_date(metadata$timeline))
}

#'@title Identify the Date of the First Release
#'@description Takes package metadata obtained with \code{\link{get_package_metadata}}
#'and returns a date object containing the date of the first CRAN package release.
#'
#'@param metadata a metadata object returned from \code{\link{get_package_metadata}}
#'
#'@examples
#'\dontrun{
#'package_metadata <- get_package_metadata("abf2")
#'earliest_release(package_metadata)
#'}
#'@export
earliest_release <- function(metadata){
  min(parse_practice_date(metadata$timeline))
}
