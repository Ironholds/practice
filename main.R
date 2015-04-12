source("config.R")
source("retrieve.R")
source("analysis.R")
dataset <- get_package_data() %>% get_content %>% parse_content
