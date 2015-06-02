# Dataset Setup and Usage
Oliver Keyes and David Robinson  
`r Sys.Date()`  

The `practice` package provides some datasets, particularly about CRAN, that make it easier to use. For maximum transparency, it is set up to construct these datasets using its own functions.

### CRAN Metadata

For example, the `CRANmetadata` package contains a list of lists, each representing metadata information about a CRAN package.

You can create or update this data yourself, using the `update_CRAN_metadata` function:


```r
practice:::update_CRAN_metadata(verbose = TRUE)
```

### Package sources

The sources of CRAN packages do *not* come included with the package, since they're ~ 5 GB and counting. However, `practice` provides a function to download them yourself:


```r
download_packages(get_package_names(), "cran_sources", quiet = FALSE)
```

This will download the sources of all packages into the `cran_sources` directory.

### Package practices

The `CRANpractices` dataset contains information on all CRAN packages and whether they follow software engineering practices. Once the package sources are downloaded as above, it can be created with:


```r
practice:::update_CRAN_practices(src_dir = "cran_sources")
```

(This takes about two minutes).  The data looks like:


```r
library(practice)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
data(CRANpractices)

CRANpractices
```

```
## Source: local data frame [6,551 x 14]
## 
##        package casing alphanumeric      license  links_to upstream_repo
## 1           A3  Upper         TRUE   GPL (>= 2)  <chr[5]>    None/Other
## 2          abc  Lower         TRUE   GPL (>= 3)  <chr[5]>    None/Other
## 3  ABCanalysis  Mixed         TRUE        GPL-3  <chr[3]>    None/Other
## 4     abcdeFBA  Mixed         TRUE        GPL-2  <chr[7]>    None/Other
## 5  ABCExtremes  Mixed         TRUE        GPL-2  <chr[2]>    None/Other
## 6     ABCoptim  Mixed         TRUE   GPL (>= 3)  <lgl[1]>        GitHub
## 7        ABCp2  Mixed         TRUE        GPL-2  <chr[1]>    None/Other
## 8     abctools  Lower         TRUE   GPL (>= 2)  <chr[6]>    None/Other
## 9          abd  Lower         TRUE        GPL-2 <chr[13]>    None/Other
## 10        abf2  Lower         TRUE Artistic-2.0  <lgl[1]>    None/Other
## ..         ...    ...          ...          ...       ...           ...
## Variables not shown: versioning (lgl), testing (chr), roxygen (lgl),
##   changelog (lgl), vignette_format (chr), vignette_builder (chr),
##   downloads (int), links_from (dbl)
```

You can use it to answer questions about the frequency of particular practices:


```r
CRANpractices %>%
  count(license) %>%
  arrange(desc(n))
```

```
## Source: local data frame [103 x 2]
## 
##         license    n
## 1    GPL (>= 2) 2611
## 2         GPL-2 1433
## 3         GPL-3  702
## 4           GPL  378
## 5    GPL (>= 3)  305
## 6           MIT  226
## 7   GPL-2/GPL-3  150
## 8        LGPL-3   73
## 9  GPL (>= 2.0)   72
## 10 BSD_3_clause   58
## ..          ...  ...
```

```r
CRANpractices %>%
  count(vignette_format, vignette_builder) %>%
  ungroup() %>%
  arrange(desc(n))
```

```
## Source: local data frame [17 x 3]
## 
##       vignette_format   vignette_builder    n
## 1                None               None 5227
## 2               LaTeX             Sweave  898
## 3            Markdown              knitr  240
## 4               LaTeX              knitr  126
## 5                 rsp              R.rsp   21
## 6      LaTeX/Markdown              knitr   10
## 7            Markdown             Sweave   10
## 8               LaTeX          highlight    7
## 9      LaTeX/Markdown       utils, knitr    2
## 10 LaTeX/Markdown/rsp       knitr, R.rsp    2
## 11                rst              knitr    2
## 12              LaTeX elliptic, emulator    1
## 13              LaTeX              noweb    1
## 14              LaTeX              utils    1
## 15          LaTeX/rst             Sweave    1
## 16           Markdown  knitr, RefManageR    1
## 17       Markdown/rsp       knitr, R.rsp    1
```
