library(ggplot2)
library(ggthemes)
library(data.table)
load("./data/CRANpractices.rda")

data <- as.data.table(CRANpractices)
results <- data[,j=list(packages=.N), by='testing']

ggsave(filename = "./paper/basic_usage.svg",
       plot = ggplot(results, aes(reorder(testing, packages), packages)) + 
                geom_bar(stat="identity", fill = "steelblue1") + coord_flip() +
                labs(title = "Unit test usage in CRAN packages", x = "Testing Approach", y = "Number of packages") +
                theme_fivethirtyeight())
