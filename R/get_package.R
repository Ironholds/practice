#'@title Retrieve a package source
#'@description \code{get_package_source} retrieves a package source, decompresses
#'it, and places it in a directory so that software engineering tests can be performed
#'on the contents. See the "See also" section for examples of these tests, and
#'\code{remove_package_source} to remove the source directory when you're done
#'using it.
#'
#'@param package_name the name of a package.
#'
#'@return a full, non-relative link to the directory the decompressed
#'package is stored in.
#'
#'@seealso
#'\code{\link{remove_package_source}} to remove the package, \code{\link{check_vignettes}}
#'to 
#'
#'@export 
get_package_source <- function(package_name){
  
  local_temp <- tempdir()
  dl_link <- download.packages(package_name, destdir = local_temp, type = "source")[1,2]
  untar(file.path(dl_link), exdir = local_temp)
  file.remove(dl_link)
  
  return(file.path(local_temp,package_name))
}

#'@title remove package source
#'@description removes the decompressed source code of a package,
#'retrieved with \code{get_package_source}, to free up storage
#'space and clean up after analysis.
#'
#'@param package_directory the full path to the directory, retrieved
#'with \code{\link{get_package_source}}.
#'
#'@export
remove_package_source <- function(package_directory){
  unlink(package_directory, recursive = TRUE, force = TRUE)
  return(invisible())
}

#'@title get metadata associated with a package on CRAN
#'@description pings the \href{http://crandb.r-pkg.org/}{crandb} CRAN metadata
#'service to retrieve metadata associated with a specific package.
#'
#'@param package_name the name of a package, which can be retrieved with
#'\code{\link{get_package_names}}
#'
#'@importFrom httr GET content user_agent
#'@importFrom jsonlite fromJSON
#'@export
get_package_metadata <- function(package_name){
  results <- GET(paste0("http://crandb.r-pkg.org/", package_name, "/all"),
                 user_agent("practice - https://github.com/Ironholds/practice"))
  results <- content(results, as = "parsed")
  if(length(names(results)) == 2 & names(results) == c("error","reason")){
    stop(results$reason)
  }
  return(results)
}

#'@title get the names of available packages
#'@description retrieves the names of available packages from whatever CRAN mirror
#'is associated with your session. These can then be passed into
#'\code{\link{get_package_metadata}} or \code{\link{get_package_source}}. The
#'results are cached locally after one call.
#'
#'@return a vector of package names that can be passed into \code{\link{get_package_metadata}}
#'or \code{\link{get_package_source}}.
#'
#'@seealso \code{\link{get_package_metadata}} or \code{\link{get_package_source}} for making
#'use of this information.
#'
#'@export
get_package_names <- function(){
  return(unname(available.packages())[,1])
}