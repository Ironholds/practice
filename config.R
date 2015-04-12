#Dependencies
library(rvest)
library(httr)
library(magrittr)

#Config variables and settings
r_base_url <- "http://cran.r-project.org/web/packages/available_packages_by_name.html"
practice_ua <- "practice - https://github.com/Ironholds/practice"
unwanted_fields <- c("SystemRequirements", "OS_type", "Priority", "Language", "Enhances","Copyright",
                     "NeedsCompilation", "Citation")
unwanted_fields_regex <- "(binaries|Classification|Reverse|views|Old|Reference|CRAN)"
source_regex <- "source$"

options(scipen = 500)

#Dir creation
dir.create(path = file.path(getwd(),"Datasets"), showWarnings = FALSE)
dir.create(path = file.path(getwd(),"Datavis"),  showWarnings = FALSE)