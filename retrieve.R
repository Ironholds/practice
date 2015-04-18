#Uses Gabor's awesome API to grab package data in an actually-human format.
get_package <- function(package){
  paste0("http://crandb.r-pkg.org/", package, "/all") %>%
    httr::GET() %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::prettify() %>%
    fromJSON() %>%
    return
}

#Actually extract the data and do interesting things to it.
extract_data <- function(package_data){
  
  #Create output object and run the "simpler" analysis.
  output <- list(package = package_data$name, #Package name
                 revision_count = length(package_data$versions)) #How many versions has it gone through?
  
  #Semantic versioning (this is easy, but not as easy as the above):
  output$is_semantically_versioned <- grepl(x = package_data$latest, pattern = "\\d{1,}\\.\\d{1,}\\.", perl = TRUE)
  
  #Earliest and latest release dates. The metacran db actually returns with %Z, but (1) you can't
  #use those with strptime and (2) it looks like UTC is the default for the actual timeline dates,
  #so! (Also, worst-case is it's a day off, and it seems improbably that that would bias things when
  #we're looking at things on an annual basis, unless the birthday paradox is rearing its head.)
  releases <- strptime(x = unname(unlist(package_data$timeline)), "%Y-%m-%dT%H:%M:%S", tz = "UTC")
  output$earliest_release_date <- lubridate::year(as.Date(min(releases)))
  output$latest_release_date <- lubridate::year(as.Date(max(releases)))
  
  #What packages are linked? We can use this (in the other direction) as a metric for
  #package importance.
  output$linked_packages <- linked_packages(package_data)
  
  #What possible repository locations are there? Which one (if any) looks like an actual repo?
  #What kind of repo? What about email addresses?
  output$repository <- repository_type(package_data)
  
  #Is it orphaned? Kindly CRAN identifies this by changing the 'Maintainer' field to
  #'Orphaned', so we can just do a comparison.
  output$orphaned <- (last_release$Maintainer == "ORPHANED")
  
  #Does it specify an R version? IOW, is R in the depends, and if so, does it have * as
  #a version number?
  output$specifies_r <- (!is.null(last_release$Depends$R) & !last_release$Depends$R == "*")
  
  #Identify package name casing
  output$package_name_case <- package_casing(package_data$name)
  
  #And now for the manky bits; identifying test, vignette and roxygenation presence,
  #along with whether there's a changelog and whether there's consistency in the internal
  #naming scheme used by functions.
  #This actually requires additional calls. But it's REALLY cool to have that data.
  package_address <- get_package_source(package_data$name)
  output$roxygen <- has_roxygen(package_address)
  output$tests <- testing_framework(package_address)
  output$vignettes <- vignette_usage(package_address)
  output$changelog <- changelog(package_address)
  output$internal_casing <- check_casing(package_address)
  system(paste("rm -rf", package_address))
  
}


  package_names <- as.data.frame(available.packages(), stringsAsFactors = FALSE)$Package
  package_urls <- paste0("http://cran.r-project.org/web/packages/", package_names, "/index.html")
  return(list(package_urls,package_names))
}

retrieve <- function(){
  as.data.frame(available.packages(), stringsAsFactors = FALSE)$Package %>%
    lapply(get_package) %>%
    lapply(extract_data) %>%
    group_data %>%
    return
}
  #Licensing
  licenses <- content$License
  licenses[licenses == ""] <- "None"
  licenses <- unlist(lapply(strsplit(licenses, "(\\||\\[)"), function(x){return(x[[1]])}))
  licenses <- gsub(x = licenses, pattern = "(\\(|\\+).*", replacement = "", perl = TRUE)
  licenses <- gsub(x = licenses, pattern = " $", replacement = "", perl = TRUE)
  licenses[licenses == "file LICENSE"] <- "Unknown"
  