fte_theme <- function() {
  
  # Generate the colors for the chart procedurally with RColorBrewer
  palette <- brewer.pal("Greys", n=9)
  color.background = palette[2]
  color.grid.major = palette[3]
  color.axis.text = palette[6]
  color.axis.title = palette[7]
  color.title = palette[9]
  
  # Begin construction of chart
  theme_bw(base_size=9) +
    
    # Set the entire chart region to a light gray color
    theme(panel.background=element_rect(fill=color.background, color=color.background)) +
    theme(plot.background=element_rect(fill=color.background, color=color.background)) +
    theme(panel.border=element_rect(color=color.background)) +
    
    # Format the grid
    theme(panel.grid.major=element_line(color=color.grid.major,size=.25)) +
    theme(panel.grid.minor=element_blank()) +
    theme(axis.ticks=element_blank()) +
    
    # Format the legend, but hide by default
    theme(legend.background = element_rect(fill=color.background)) +
    theme(legend.text = element_text(size=12,color=color.axis.title)) +
    theme(legend.title = element_text(size=12)) + 
    theme(legend.key = element_rect(fill=color.background)) +
    # Set title and axis labels, and format these and tick marks
    
    theme(plot.title=element_text(color=color.title, size=16, vjust=1.25, family = "CenturySch")) +
    theme(axis.text.x=element_text(size=12,color=color.axis.text)) +
    theme(axis.text.y=element_text(size=12,color=color.axis.text)) +
    theme(axis.title.x=element_text(size=12,color=color.axis.title, vjust=0)) +
    theme(axis.title.y=element_text(size=12,color=color.axis.title, vjust=1.25)) +
    # Plot margins
    theme(plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"))
}

testing_status <- function(dataset){
  test_aggregate <- ddply(.data = dataset,
                          .variables = "first_published",
                          .fun = function(x){
                            results <- as.data.frame(table(x$has_tests), stringsAsFactors = FALSE)
                            results$percentage <- results$Freq/sum(results$Freq)
                            results
                          })
  ggsave(filename = file.path(getwd(),"Datavis", "test_usage_over_time.svg"),
         plot = ggplot(test_aggregate, aes(first_published, percentage, type = Var1, group = Var1, colour = Var1)) +
           geom_line(size = 1.5) +
           scale_y_continuous(labels = percent) +
           scale_x_continuous(breaks = seq(min(test_aggregate$first_published), max(test_aggregate$first_published), 2)) +
           scale_colour_discrete(name = "Unit test status") +
           fte_theme() +
           labs(title = "Unit test framework usage in CRAN packages, by year of publication",
                x = "Date of first publication to CRAN",
                y = "Proportion (%)"))
  
  overall_testing <- table(dataset$has_tests)
  overall_testing <- as.data.frame(overall_testing/sum(overall_testing), stringsAsFactors = FALSE)
  overall_testing$Class <- "Testing framework usage"
  return(overall_testing)
}

documentation_status <- function(dataset){
  is_rox <- dataset$is_roxygenised == TRUE
  dataset$is_roxygenised[is_rox] <- "Uses roxygen2"
  dataset$is_roxygenised[!is_rox] <- "Does not use roxygen2"
  roxygen_aggregate <- ddply(.data = dataset,
                             .variables = "first_published",
                             .fun = function(x){
                               results <- as.data.frame(table(x$is_roxygenised), stringsAsFactors = FALSE)
                               results$percentage <- results$Freq/sum(results$Freq)
                               results
                             })
  
  ggsave(filename = file.path(getwd(),"Datavis", "roxygen2_usage_over_time.svg"),
         plot = ggplot(roxygen_aggregate, aes(first_published, percentage, type = Var1, group = Var1, colour = Var1)) +
           geom_line(size = 1.5) +
           scale_y_continuous(labels = percent) +
           scale_x_continuous(breaks = seq(min(test_aggregate$first_published), max(test_aggregate$first_published), 2)) +
           scale_colour_discrete(name = "Roxygen2 usage status") +
           fte_theme() +
           labs(title = "Roxygen2 usage in CRAN packages, by year of first publication",
                x = "Date of first publication to CRAN",
                y = "Proportion (%)"))
  
  overall_roxygenation <- table(dataset$is_roxygenised)
  overall_roxygenation <- as.data.frame(overall_roxygenation/sum(overall_roxygenation), stringsAsFactors = FALSE)
  overall_roxygenation$Class <- "Roxygen2 usage"
  
  
}

