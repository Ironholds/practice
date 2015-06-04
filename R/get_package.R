#' Retrieve a package source
#'
#' \code{get_package_source} retrieves a package source, decompresses it, and
#' places it in a directory so that software engineering tests can be performed
#' on the contents. See the "See also" section for examples of these tests, and
#' \code{\link{remove_package_source}} to remove the source directory when
#' you're done using it.
#'
#' @param package_name the name of a package.
#'
#' @return a full, non-relative link to the directory the decompressed package
#'   is stored in.
#'
#' @seealso \code{\link{remove_package_source}} to remove the package,
#'   \code{\link{get_package_metadata}} to get the metadata associated with a
#'   package, or \code{\link{get_package_names}} to retrieve a listing of the
#'   names of packages on CRAN.
#'
#' @examples
#' \dontrun{
#' # Get the package source for urltools
#' file_location <- get_package_source("urltools")
#' file_location
#' dir(file_location)
#' }
#' @export
get_package_source <- function(package_name) {

  local_temp <- tempdir()
  dl_link <- download.packages(package_name, destdir = local_temp,
                               type = "source", quiet = TRUE)[1, 2]
  untar(file.path(dl_link), exdir = local_temp)
  file.remove(dl_link)

  return(file.path(local_temp, package_name))
}

#' Download multiple package sources from CRAN.
#'
#' Download multiple package sources from CRAN, saving them to a
#' directory. This can be used in a meta-analysis of CRAN.
#'
#' @param package_names character vector of one or more package names
#' @param dir directory to save packages to
#' @param quiet whether package download messages should be suppressed
#'
#' @export
download_packages <- function(package_names, dir, quiet = TRUE) {
  dir.create(dir, showWarnings = FALSE)

  download0 <- dplyr::failwith(NULL, download.packages)

  for (package_name in package_names) {
    cat(package_name, "\n")
    if (file.exists(file.path(dir, package_name))) {
      next
    }
    dl <- download0(package_name, destdir = dir, type = "source", quiet = quiet)
    if (length(dl) != 0) {
      dl_link <- dl[1, 2]
      untar(file.path(dl_link), exdir = dir)
      file.remove(dl_link)
    }
  }
}

#' Remove package source
#'
#' Removes the decompressed source code of a package, retrieved with
#' \code{\link{get_package_source}}, to free up storage space and clean up after
#' analysis.
#'
#' @param package_directory the full path to the directory, retrieved with
#'   \code{\link{get_package_source}}.
#'
#' @export
remove_package_source <- function(package_directory) {
  unlink(package_directory, recursive = TRUE, force = TRUE)
  return(invisible())
}

#' Get metadata associated with a package on CRAN
#'
#' Pings the \href{http://crandb.r-pkg.org/}{crandb} CRAN metadata service to
#' retrieve metadata associated with a specific package.
#'
#' @param package_name the name of a package, which can be retrieved with
#'   \code{\link{get_package_names}}
#' @param all whether to return all versions of the package, as opposed to only
#'   the most recent
#'
#' @return a named list containing the metadata associated with the package.
#'
#' @examples
#' \dontrun{
#' #Get the metadata associated with dplyr
#' dplyr_metadata <- get_package_metadata("dplyr")
#' str(dplyr_metadata, max.level = 2)
#' }
#' @seealso \code{\link{get_package_source}} and
#' \code{\link{remove_package_source}} for the content of a package, and
#' \code{\link{get_package_names}} to retrieve a listing of the names of
#' packages on CRAN.
#'
#' @importFrom httr GET content user_agent
#' @importFrom jsonlite fromJSON
#'  @export
get_package_metadata <- function(package_name, all = TRUE) {

  url <- paste0("http://crandb.r-pkg.org/", package_name)
  if (all) {
    url <- paste0(url, "/all")
  }
  results <-
    httr::GET(url,
              user_agent("practice - https://github.com/Ironholds/practice"))
  results <- content(results, as = "parsed")
  if (length(names(results)) == 2 && names(results) == c("error", "reason")) {
    stop(results$reason)
  }
  return(results)
}

#' Get the names of available packages
#'
#' Retrieves the names of available packages from whatever CRAN mirror is
#' associated with your session. These can then be passed into
#' \code{\link{get_package_metadata}} or \code{\link{get_package_source}}. The
#' results are cached locally after one call.
#'
#' @return a vector of package names that can be passed into
#'   \code{\link{get_package_metadata}} or \code{\link{get_package_source}}.
#'
#' @seealso \code{\link{get_package_metadata}} or
#'   \code{\link{get_package_source}} for making use of this information.
#'
#' @export
get_package_names <- function(){
  return(unname(available.packages())[, 1])
}
