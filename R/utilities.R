#This actually checks the content of all .R files to see if a regex is matched or not.
check_content <- function(package_directory, regex, ...){
  
  files <- list.files(path = package_directory, pattern = "\\.R$", full.names = TRUE,
                      recursive = TRUE, ignore.case = TRUE)
  output <- FALSE
  for(file in files){
    content <- readChar(file, file.info(file)$size)
    if(grepl(x = content, pattern = regex, ...)){
      output <- TRUE
      break
    }
  }
  return(output)
}