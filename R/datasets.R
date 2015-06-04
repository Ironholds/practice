#' Download metadata from multiple packages to a file
#'
#' Download metadata from multiple packages to a file. This is useful for larger
#' analyses of CRAN.
#'
#' @param package_names Character vector of package names; retrievable with
#'   \code{\link{get_package_names}}
#' @param verbose Whether package names should be displayed as they are
#'   downloaded
#' @param ... Extra arguments passed on to \code{\link{get_package_metadata}}
#'
#' @return A named list, one component for each package, containing a list of
#'   metadata for the package. This list contains the contents from the
#'   \href{https://github.com/metacran/crandb}{CRAN API}, with one field added:
#'   \code{retrieved}, a \code{\link[=DateTimeClasses]{POSIXct}} object with
#'   the time that the data was retrieved.
#'
#' @examples
#' foo <- download_packages_metadata(c("broom", "tidyr"))
#' str(foo, max.level = 2)
#'
#' @export
download_packages_metadata <- function(package_names, verbose = FALSE, ...) {
  ret <- lapply(package_names, function(package_name) {
    if (verbose) {
      cat(package_name, sep = "\n")
    }
    ret <- get_package_metadata(package_name, ...)
    ret$retrieved <- Sys.time()
    return(ret)
  })
  names(ret) <- package_names
  return(ret)
}


#' Update the CRAN metadata dataset
#'
#' Download metadata from all CRAN packages, and save it into a directory (by
#' default, \code{data}). This is used to create the \code{\link{CRANmetadata}}
#' dataset.
#'
#' @param data_dir Output directory to write \code{CRANmetadata.rda}
#' @param all Whether all versions should be downloaded, or just the latest
#'   version (by default, only latest version)
#' @param ... Extra arguments passed on to
#'   \code{\link{download_packages_metadata}}
#'
#' @return The \code{\link{CRANmetadata}} object, invisibly
update_CRAN_metadata <- function(data_dir = "data", all = FALSE, ...) {
  dir.create(data_dir, showWarnings = FALSE)
  pkgs <- get_package_names()
  CRANmetadata <- download_packages_metadata(pkgs, all = all, ...)
  save(CRANmetadata, file = file.path(data_dir, "CRANmetadata.rda"))

  invisible(CRANmetadata)
}


#' Update the CRAN practices dataset
#'
#' Check all CRAN practices, and save them to a directory.
#'
#' @param data_dir Output directory to write \code{CRANpractices.rda}
#' @param src_dir Directory of package sources
#' @param ... extra arguments passed on to \code{\link{check_practices}}
#'
#' @details This works with the current version of the
#'   \code{\link{CRANmetadata}} dataset (make sure you've re-built the package
#'   if you've updated that dataset).
update_CRAN_practices <- function(data_dir = "data", src_dir = NULL, ...) {
  dir.create(data_dir, showWarnings = FALSE)

  pkgs <- get_package_names()

  CRANpractices <- check_practices(pkgs, metadata_lst = CRANmetadata,
                                   src_dir = src_dir, ...)

  save(CRANpractices, file = file.path(data_dir, "CRANpractices.rda"))
}


#' Metadata from all CRAN packages
#'
#' A list of the metadata for each package.
#'
#' @name CRANmetadata
#'
#' @format A named list.
NULL


#' Checks on practices of each package in CRAN
#'
#' A list of the metadata for each package.
#'
#' @name CRANpractices
#'
#' @format A tbl_df with one row for each package.
NULL
