#Scrape the base CRAN url (stored as r_base_url in config.R) for URLs to each package. The data we're
#looking for /should/ be available through available.packages(), but I'll be damned if I can work out
#how to get it to give me actual, non-standard fields like BugReports or URLs.
get_package_data <- function(){
  package_names <- as.data.frame(available.packages(), stringsAsFactors = FALSE)$Package
  package_urls <- paste0("http://cran.r-project.org/web/packages/", package_names, "/index.html")
  return(list(package_urls,package_names))
}

#Retrieve the content; for each package name and URL, go to the index page, scrape the data described,
#turn it into a key-value pair data.frame, associate the package name and return, before binding
#the whole thing together into one big data.frame. Then clean it a bit, of course, to remove
#things we don't care about and sanitise key names.
get_content <- function(package_data){
  content <- mapply(function(url, name){
    page <- html(url, user_agent(practice_ua))
    content <- html_nodes(page, "td")
    data <- html_text(content)
    results <- as.data.frame(matrix(data, nrow = length(data)/2, byrow = TRUE), stringsAsFactors = FALSE)
    names(results) <- c("field","value")
    results$package <- name
    return(results)
  }, package_data[[1]], package_data[[2]], SIMPLIFY = FALSE)
  content <- do.call("rbind",content)
  rownames(content) <- NULL
  content$field <- gsub(x = content$field, pattern = "( |:)", replacement = "")
  content <- content[!content$field %in% unwanted_fields,]
  content <- content[!grepl(x = content$field, pattern = unwanted_fields_regex),]
  content$field[grepl(x = content$field, pattern = source_regex, perl = TRUE)] <- "download_url"
  write.table(content, file = file.path(getwd(),"Datasets","raw_data.tsv"), quote = TRUE, sep = "\t",
              row.names = FALSE)
  return(content)
}

#Takes the data.frame now stored in raw_data.tsv and turns it into a list of values calculated from each field.
parse_content <- function(content){
  results <- dlply(.data = content,
                   .variables = "package",
                   .fun = function(x){
                     
                     output <- list(
                       name = x$package[1],
                       semantic_versioning = NA,
                       dependencies = NA,
                       authors = NA,
                       is_orphaned = FALSE,
                       upstream_available = NA,
                       naming_scheme = NA
                     )
                     
                     #Semantically versioned?
                     if(!check_null(x, "Version")){
                       output$semantic_versioning <- grepl(x = x$value[x$field == "Version"],
                                                           pattern = "\\d{1,}\\.\\d{1,}\\.")
                     }
                     
                     #Dependencies noted? Yank them out.
                     if(!check_null(x, "Depends")){
                       output$dependencies <- unname(unlist(strsplit(x = x$value[x$field == "Depends"], split = ",")))
                     }
                     
                     #Authors?
                     if(!check_null(x, "Author")){
                       output$authors <- gsub(x = unname(unlist(strsplit(x = x$value[x$field == "Depends"],
                                                                         split = "( and |\\n|,)"))),
                                              pattern = "( {1,}(<.*>|\\[.*\\>))", replacement = "")
                     }
                     return(output)
                   })
}