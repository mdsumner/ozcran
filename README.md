
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ozcran

<!-- badges: start -->

<!-- badges: end -->

The goal of ozcran is to check the status and packages available from
Australian CRAN mirrors.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mdsumner/ozcran")
```

## Example

This is a basic example which gets the package list from Australian CRAN
mirrors and provides a quick summary.

``` r
library(ozcran)

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
db <- oz_db() 

db %>% group_by(repos) %>% summarize(n = n(), date = max(as.Date(Published), na.rm = TRUE)) %>% arrange(desc(date))
#> # A tibble: 5 x 3
#>   repos       n date      
#>   <chr>   <int> <date>    
#> 1 aws     14594 2019-07-22
#> 2 curtin  14594 2019-07-21
#> 3 aarnet  14569 2019-07-15
#> 4 csiro   14569 2019-07-15
#> 5 unimelb 14567 2019-07-15
```
