library(ggplot2)
library(ggthemes)
library(lubridate)
library(data.table)
load("./data/CRANpractices.rda")

data <- as.data.table(CRANpractices)
data$first_release <- lubridate::year(data$first_release)
data$last_release <- lubridate::year(data$last_release)

results <- data[,j=list(packages=.N), by='testing']

ggsave(filename = "./paper/basic_usage.svg",
       plot = ggplot(results, aes(reorder(testing, packages), packages)) + 
                geom_bar(stat="identity", fill = "steelblue1") + coord_flip() +
                labs(title = "Unit test usage in CRAN packages", x = "Testing Approach", y = "Number of packages") +
                theme_fivethirtyeight())

data$has_any_tests <- !(data$testing == "None")
initial_results <- data[,j=list(packages={
    sum(.SD$has_any_tests)/.N}), by= "first_release"]
