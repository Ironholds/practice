library(ggplot2)
library(ggthemes)
load("./data/CRANpractices.rda")
results <- as.data.frame(table(CRANpractices$testing))
ggsave(filename = "./paper/basic_usage.svg",
       plot = ggplot(results, aes(reorder(Var1, Freq), Freq)) + geom_bar(stat="identity", fill = "steelblue1") + coord_flip() +
         labs(title = "Unit test usage in CRAN packages", x = "Foo", y = "Bar") + theme_fivethirtyeight())
