#' @title Check all the practices of a package on CRAN
#'
#' @description Given the name of a package on CRAN, retrieve the source
#' and. Then run all tests in the practice package, returning a one-row
#' data frame with information on the package.
#'
#' @param package_name character vector with the names of one or more packages
#' on CRAN
#' @param metadata_lst List of package metadata objects
#' @param src_dir If given, a directory that holds sources of the packages
#' @param error whether the function should raise an error if any individual
#' package does. If FALSE, shows the error message but continues
#'
#' @details This relies entirely on other functions in the practice package.
#'
#' @return A tbl_df with one row for each package, and columns describing
#' the practices followed by each.
#'
#' @examples
#' 
#' \dontrun{
#' check_practices("urltools")
#' 
#' # check multiple packages
#' practices <- check_practices(c("urltools", "ggplot2", "dplyr", "survival"))
#' practices
#'  
#' # extract what packages each links to
#' library(dplyr)
#' library(tidyr)
#' 
#' practices %>%
#'   select(package, links_to) %>%
#'   unnest(links_to)
#' }
#' 
#' @export
check_practices <- function(package_name, metadata_lst = NULL, src_dir = NULL,
                            error = TRUE) {
  if (length(package_name) > 1) {
    if (error) {
      func <- check_practices
    } else {
      func <- dplyr::failwith(NULL, check_practices)
    }
    ret <- plyr::ldply(package_name, func,
                  metadata_lst = metadata_lst,
                  src_dir = src_dir,
                  error = error)
    return(dplyr::tbl_df(ret))
  }
  
  cat(package_name, sep = "\n")
  
  if (is.null(metadata_lst)) {
    metadata <- get_package_metadata(package_name)
  } else {
    metadata <- metadata_lst[[package_name]]
  }
  
  latest <- check_metadata(metadata)
  
  if (is.null(src_dir)) {
    src <- get_package_source(package_name)
  } else {
    src <- file.path(src_dir, package_name)
  }

  naming = check_package_naming(latest)
  vignettes <- check_vignettes(src)
  
  # readChar, and therefore check_testing/check_roxygen, might fail if
  # there are UTF-8 files. As a temporary workaround, we use NA in its place
  check_testing0 <- dplyr::failwith(NA, check_testing, quiet = TRUE)
  check_roxygen0 <- dplyr::failwith(NA, check_roxygen, quiet = TRUE)

  ret <- dplyr::data_frame(
    package = package_name,
    casing = naming$casing,
    alphanumeric = naming$alphanumeric,
    license = paste(get_license(latest), collapse = "/"),
    links_to = make_vector_list(links_to(latest)),
    upstream_repo = check_upstream_repository(latest),
    versioning = check_versioning(latest),
    testing = check_testing0(src),
    roxygen = check_roxygen0(src),
    changelog = check_changelog(src),
    vignette_format = vignettes$Format,
    vignette_builder = vignettes$Builder
  )

  
  if (!is.null(metadata$latest)) {
    ret$links_from <- links_from(metadata)
  }
  
  ret
}


#' If a vector is of length greater than 1, make it a list;
#' if it's NULL, return NA
#' 
#' This is useful for creating a data frame that may have
#' list-columns
#' 
#' @param x a vector
make_vector_list <- function(x) {
  if (length(x) > 1) {
    list(x)
  } else if (length(x) == 0) {
    NA
  } else {
    x
  }
}
