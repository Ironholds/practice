# Software engineering practices in R Packages

##Description
This package provides functions to check a CRAN package (or a set of CRAN packages) against common software engineering expectations. In particular, it enables a user to identify if a package:

1. Has unit tests (and what form these tests take);
2. Uses semantic versioning;
3. Has long-form vignette-based documentation (and how it is built);
4. Has roxygen2 documentation;
5. And a whole host of things besides. See [the vignette](https://github.com/Ironholds/practice/blob/master/vignettes/Introduction.Rmd) for the full list.

It was initially written by Oliver Keyes for a research collaboration with [Jenny Bryan](https://github.com/jennybc) and [David Robinson](https://github.com/dgrtwo), which is documented [here](https://github.com/Ironholds/practice/tree/master/paper), but should be generalisable and pretty usable to other people.

##Installation

    devtools::install_github("ironholds/practice")

##Dependencies

1. R
2. [httr](http://cran.r-project.org/web/packages/httr/index.html)
3. [jsonlite](http://cran.r-project.org/web/packages/jsonlite/index.html)