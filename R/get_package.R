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

#' Get metadata associated with CRAN packages
#'
#' Retrieve metadata for one, several, or all packages from the
#' \href{http://crandb.r-pkg.org/}{crandb} CRAN metadata service.
#'
#' @param package_name character vector of package names or \code{NULL}, which
#'   requests download for all CRAN packages
#' @param version either "all" or "latest", indicating whether to return
#'   metadata on all versions of a package or just the most recent; defaults to
#'   "latest" when user supplies non-\code{NULL} value for \code{package_name};
#'   ignored if \code{package_name = NULL} because the API always returns
#'   metadata on all versions in that case
#' @param archived logical indicator requesting or suppressing the inclusion of
#'   metadata for archived packages; only relevant when \code{package_name =
#'   NULL}, i.e. when retrieving metadata for all CRAN packages
#' @param verbose Whether package names should be displayed as they are
#'   downloaded; ignored when downloading a single packages or all packages at
#'   once
#'
#' @return A named list containing the metadata associated with a single package
#'   or a named list with such a component for each requested package. This list
#'   contains the contents from the
#'   \href{https://github.com/metacran/crandb}{CRAN API}, with one field added:
#'   \code{retrieved}, a \code{\link[=DateTimeClasses]{POSIXct}} object with the
#'   time that the data was retrieved.
#'
#' @examples
#' \dontrun{
#' ## get all versions of all CRAN packages, even archived ones
#' everything <- get_package_metadata()
#' str(everything, max.level = 1, list.len = 5)
#'
#' ## filter out the archived packages
#' not_archived <- get_package_metadata(archived = FALSE)
#' str(not_archived, max.level = 1, list.len = 5)
#'
#' ## get metadata for latest version of a specific package
#' get_package_metadata("dplyr")
#'
#' ## get metadata for all versions of a specific package
#' get_package_metadata("dplyr", version = "all")
#'
#' ## get metadata for latest version of selected packages
#' just_a_few <- get_package_metadata(c("dplyr", "broom", "lattice", "car"))
#'
#' }
#' @seealso \code{\link{get_package_source}} and
#'   \code{\link{remove_package_source}} for the content of a package, and
#'   \code{\link{get_package_names}} to retrieve a listing of the names of
#'   packages on CRAN.
#'
#' @importFrom httr GET content user_agent
#' @importFrom jsonlite fromJSON
#' @export
get_package_metadata <- function(package_name = NULL, version = NULL,
                                 archived = is.null(package_name),
                                 verbose = NULL) {

  url <- base_url <- "http://crandb.r-pkg.org/"
  if (is.null(package_name)) {
    url <- paste0(url, "-/all")
    if (archived) {
      url <- paste0(url, "all")
    }
    if (!is.null(version)) {
      message(paste("When retrieving metadata for all CRAN packages,",
                    "the API always returns data for all versions.",
                    "Ignoring the \"version\" argument...."))
    }
    verbose <- FALSE
  } else {
    stopifnot(is.character(package_name))
    version <- match.arg(version, c("latest", "all"))
    url <- paste0(url, package_name)
    if (identical(version, "all")) {
      url <- paste0(url, "/all")
    }
    if (!is.null(archived) && !identical(archived, FALSE)) {
      message(paste("When retrieving metadata for specific CRAN packages,",
                    "the \"archived\" argument is not consulted."))
    }
    if (is.null(verbose)) verbose <- TRUE
  }

  retval <- lapply(url, function(x) {
    if (verbose && !is.null(package_name)) {
      cat(gsub(base_url, '', x), sep = "\n")
    }
    results <-
      httr::GET(x,
                httr::user_agent("practice - https://github.com/Ironholds/practice"))
    results <- httr::content(results, as = "parsed")
    if (length(names(results)) == 2 &&
        names(results) == c("error", "reason")) {
      results <- NULL
    }
    results$retrieved <- Sys.time()
    results
  })

  if (any(not_found <- vapply(retval, is.null, logical(1)))) {
    warning(paste("Can't find package(s) with these name(s):\n",
                  paste(package_name[not_found], collapse = ", "),
                  "\nCorresponding list component will be NULL."))
  }

  if(is.null(package_name) || length(package_name) == 1L) {
    retval <- retval[[1]]
    if(is.null(package_name)) {
      retval[[length(retval)]] <- NULL ## API sends date in last component
    }
  }
  retval

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
