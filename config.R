#Dependencies
library(rvest)
library(httr)
library(magrittr)
library(tidyr)
library(stringi)
library(plyr)
library(ggplot2)
library(gridExtra)
library(RColorBrewer)

#Config variables and settings
r_base_url <- "http://cran.r-project.org/web/packages/available_packages_by_name.html"
practice_ua <- "practice - https://github.com/Ironholds/practice"
unwanted_fields <- c("SystemRequirements", "OS_type", "Priority", "Language","Copyright","NeedsCompilation",
                     "Citation","ClassificationACM", "ClassificationMSC", "ClassificationJEL",
                     "OSXSnowLeopardbinaries", "OSXMavericksbinaries", "Reverseenhances", "Reversesuggests",
                     "CRANchecks", "Windowsbinaries", "Packagesource", "Reversedepends", "Reverseimports",
                     "Reverselinkingto")

[1] "Version"                "Depends"                "Suggests"               "Published"              "Author"                
[6] "Maintainer"             "License"                "NeedsCompilation"       "Citation"               "Materials"             
[11] "CRANchecks"             "Referencemanual"        "Packagesource"          "Windowsbinaries"        "OSXSnowLeopardbinaries"
[16] "OSXMavericksbinaries"   "Oldsources"             "Inviews"                "Vignettes"              "Reversedepends"        
[21] "Imports"                "URL"                    "ClassificationACM"      "ClassificationJEL"      "Reverseimports"        
[26] "Reversesuggests"        "SystemRequirements"     "LinkingTo"              "Enhances"               "Copyright"             
[31] "Reverseenhances"        "BugReports"             "ClassificationMSC"      "Reverselinkingto"       "Contact"               
[36] "OS_type"                "Priority"               "Language"              

unwanted_fields_regex <- "(binaries|Classification|views|Old|Reference|CRAN)"
source_regex <- "source$"

options(scipen = 500)

#Dir creation
dir.create(path = file.path(getwd(),"Datasets"), showWarnings = FALSE)
dir.create(path = file.path(getwd(),"Datavis"),  showWarnings = FALSE)
