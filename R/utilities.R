check_file <- function(filename, regex, ...) {
  content <- readChar(filename, file.info(filename)$size)
  grepl(x = content, pattern = regex, ...)
}

#This actually checks the content of all .R files to see if a regex is matched or not.
check_content <- function(package_directory, regex, ...){
  files <- list.files(path = package_directory, pattern = "\\.R$", full.names = TRUE,
                      recursive = TRUE, ignore.case = TRUE)
  for (file in files) {
    if (check_file(file, regex, ...)) {
      return(TRUE)
    }
  }
  return(FALSE)
}

#' This identifies if the input argument is metadata, and goes to grab it
#' if not.
#' 
#' @param metadata package name or metadata list
#' @param latest If TRUE, and if the metadata contains multiple versions,
#' it returns only the most recent one.
check_metadata <- function(metadata, latest = TRUE) {
  if (!is.list(metadata)) {
    metadata <- get_package_metadata(metadata, all = !latest)
  }
  
  if (!is.null(metadata$latest) && latest) {
    metadata <- metadata$versions[[metadata$latest]]
  }
  
  metadata
}
