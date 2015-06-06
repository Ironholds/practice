#'@title identify packages that a package mentions
#'@description this identifies unique packages that are linked to by the package
#'that is being evaluated, in the context of dependencies, suggests and LinkingTo fields.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}},
#'or the name of a package (in which case \code{get_package_metadata} will be called
#'internally).
#'
#'@param with_versions whether to return the version number (or lack thereof) as well as the
#'mentioned package's name. Set to FALSE by default.
#'
#'@return a vector of package names, if \code{with_versions} is FALSE, or a data.frame
#'of "package" and "version", if TRUE.
#'
#'@export
links_to <- function(package_metadata, with_versions = FALSE){
  last_release <- check_metadata(package_metadata)

  if(with_versions){
    versioned_vec <- unlist(c(last_release$Depends, last_release$Imports, last_release$Suggests, last_release$Enhances))
    versioned <- data.frame(package = names(versioned_vec), version = versioned_vec,
                            stringsAsFactors = FALSE)
    rownames(versioned) <- NULL
    return(versioned[!duplicated(versioned),])
  }
  return(unique(c(names(last_release$Depends),names(last_release$Imports), names(last_release$Suggests), names(last_release$Enhances))))
}

#'@title Get a count of packages that mention a specific package
#'@description consumes packageX's metadata and returns a count
#'of how many packages depend on it.
#'
#'@param package_metadata package metadata retrieved with \code{\link{get_package_metadata}},
#'or the name of a package (in which case \code{get_package_metadata} will be called
#'internally).
#'
#'@details we don't (currently) have more than a count of how many reverse depends,
#'imports, suggests etc a package has, otherwise we'd be mimicking the functionality
#'of \code{\link{links_to}}.
#'@return a one-element, numeric vector containing a count of how many packages depend
#'on the package \code{package_metadata} covers.
#'
#'@export
links_from <- function(package_metadata){
  package_metadata <- check_metadata(package_metadata, version = "all")
  if (is.null(package_metadata$revdeps)){
    return(0)
  }
  return(package_metadata$revdeps)
}
