#'@title retrieve the number of downloads of a package
#'@description this identifies the number of downloads
#'of packages from the RStudio CRAN mirror; it can be
#'used as a measure of package popularity and,
#'by extension, a measure of the importance of a particular
#'package having good engineering standards
#'
#'@param packages the name of a package, or a vector of
#'multiple package names.
#'
#'@param start_date the start of the date range to cover.
#'
#'@param end_date the end of the date range to cover.
#'
#'@param all whether to retrieve data for all packages,
#'rather than one specific package. Set to FALSE by
#'default.
#'
#'@examples
#'#ggplot2 downloads in March 2015
#'check_downloads("ggplot2", "2015-03-01", "2015-03-31")
#'
#'#all package downloads on 1-2nd April
#'check_downloads(NULL, "2015-04-01", "2015-04-02", all = TRUE)
#'
#'@export
check_downloads <- function(packages = NULL, start_date, end_date, all = FALSE){
  if(length(packages) > 1){
    packages <- paste(packages, collapse = ",")
  }
  url <- paste0("http://cranlogs.r-pkg.org/downloads/total/",
                start_date, ":", end_date)
  if(!all){
    url <- paste0(url,"/",packages)
  }
  results <- GET(url, user_agent("practice - https://github.com/Ironholds/practice"))
  results <- content(results, as = "parsed", type = "application/json")
  if(length(results) == 2 && names(results) == c("error","info")){
    stop(results$error)
  }
  
  results <- unlist(lapply(results, function(x){return(x$downloads)}))
  return(results)
}