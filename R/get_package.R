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
  dl_link <- download.packages(package_name, destdir = local_temp)[1,2]
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

#'@importFrom httr GET content user_agent
#'@importFrom jsonlite prettify fromJSON
get_package_metadata <- function(package_name){
  paste0("http://crandb.r-pkg.org/", package_name, "/all") %>%
    GET(user_agent("practice - https://github.com/Ironholds/practice")) %>%
    content(as = "text", encoding = "UTF-8") %>%
    prettify() %>%
    fromJSON() %>%
    return
}