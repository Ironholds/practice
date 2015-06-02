# Introduction to the `practice` package
Oliver Keyes  
`r Sys.Date()`  

`practice` is an R package for identifying whether *other* R packages follow common software engineering and usability conventions.


## Data retrieval

To do anything with `practice` you need data about a package (or a set of packages) - either the metadata, or the actual source code of the package.

Metadata is provided with `get_package_metadata`, which hooks into [Gábor Csárdi](https://github.com/gaborcsardi)'s wonderful [crandb](https://github.com/metacran/crandb) database of CRAN metadata. It accepts a single argument - the name of a package - and returns a named list of all the metadata *associated* with that package.

Source code can be obtained with `get_package_source`: like metadata, it accepts the package name as an argument. Unlike metadata, it returns the full path to a temporary, uncompressed version of the package's source code, which can be passed into other functions until you're done with it - at which point passing it into `remove_package_source` will delete the local copy.

Just in case you want to run this analysis over a lot of R packages, we've also got `get_package_names`, which does what it says on the tin: returns a character vector containing the names of every package on CRAN. Then you can pass them into the other data retrieval functions as much as you want.

## Testing, versioning and patching
For software to be trusted, it has to be tested - reliably, consistently, and in a way third-parties can understand. These days, that means unit tests. R has two frameworks for unit tests, RUnit (which is orphaned, but still used) and testthat (which is regularly used, and regularly maintained). Both present in totally different ways, and a package author doesn't have to use either - they could use no tests, or tests they wrote themselves without any kind of testing framework to place them in.

`practice` provides `check_testing`, which accepts the path to the package source code and tells you what kind of tests are in use, if any:


```r
library(practice)
source_location <- get_package_source("urltools")
check_testing(source_location)
#[1] "testthat"
remove_package_source(source_location)
```

Full documentation can be found at `?check_testing`.

Versioning is also important - not so much for ad-hoc analysis as for packages that *depend* on a package. How do you tell if a version number being bumped means a total overhaul of the API or not? How do you tell if it's added new functionality you might want to check out and take advantage of? The answer is [semantic versioning](http://semver.org/), which uses three, period-separated numbers to identify the version of a codebase. 1.0.0 changing to 1.0.1 means a bugfix; 1.1.0 means backwards-compatible new functionality; 2.0.0 means breaking changes. <code>check_versioning</code>, when provided with package metadata, provides a TRUE or FALSE to the question "is this package semantically versioned?" Simple and hard to fool.

And finally we have the scenario where a package has a bug (due to an absence of tests) and you want to submit a patch (bumping the version number). Does it have an upstream repository? And the answer comes back: sometimes! And it could be in many different places! It could be GitHub or R-Forge or Google Code or Bitbucket or an email address to throw error messages at. And consistency and openness is pretty useful for ensuring quality code, since "many eyes...".

`practice` provides `check_upstream_repository`, which consumes metadata and tells you if there's a link to "GitHub", "R-Forge", "BitBucket", "Email" or "Other/None".

## Documentation

## Miscellanea
