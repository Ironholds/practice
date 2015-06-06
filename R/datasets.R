#' Update the CRAN metadata object and rda file
#'
#' Download metadata from all CRAN packages, and save it into a directory (by
#' default, \code{data}). This is used to create the \code{\link{CRANmetadata}}
#' dataset.
#'
#' @param data_dir Output directory to write \code{CRANmetadata.rda}
#' @param ... Extra arguments passed on to
#'   \code{\link{get_package_metadata}}
#'
#' @return The \code{\link{CRANmetadata}} object, invisibly
update_CRAN_metadata <- function(data_dir = "data", ...) {
  dir.create(data_dir, showWarnings = FALSE)
  CRANmetadata <- get_package_metadata(...)
  save(CRANmetadata,
       file = file.path(data_dir, "CRANmetadata.rda"), compress = 'xz')

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
