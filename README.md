
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ozcran

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/mdsumner/ozcran.svg?branch=master)](https://travis-ci.org/mdsumner/ozcran)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/mdsumner/ozcran?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/ozcran)
[![Codecov test
coverage](https://codecov.io/gh/mdsumner/ozcran/branch/master/graph/badge.svg)](https://codecov.io/gh/mdsumner/ozcran?branch=master)
<!-- badges: end -->

The goal of ozcran is to check the status and packages available from
Australian CRAN mirrors.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("mdsumner/ozcran")
```

## Example

This is a basic example which gets the package list from Australian CRAN
mirrors and provides a quick summary.

``` r
library(ozcran)

library(dplyr)
db <- oz_db() 
dim(db)
#> [1] 87487    65
```

`db` now is a data frame with lots of fields about every package, and
reflects the status of at least five online mirrors. The mirror itself
is named in the `repos` column.

Group by repository and find a summary of currency and number of
packages.

``` r
db %>% group_by(repos) %>% 
  summarize(n = n(), date = max(as.Date(Published), na.rm = TRUE)) %>% 
  arrange(desc(date))
#> # A tibble: 6 x 3
#>   repos       n date      
#>   <chr>   <int> <date>    
#> 1 aws     14594 2019-07-22
#> 2 private 14594 2019-07-22
#> 3 curtin  14594 2019-07-21
#> 4 aarnet  14569 2019-07-15
#> 5 csiro   14569 2019-07-15
#> 6 unimelb 14567 2019-07-15
```

We can also compare to the source CRAN mirror that is in Austria (no
kangaroos).

``` r
oz_db(include_cran = TRUE) %>% group_by(repos) %>% 
  summarize(n = n(), date = max(as.Date(Published), na.rm = TRUE)) %>% 
  arrange(desc(date))
#> # A tibble: 7 x 3
#>   repos       n date      
#>   <chr>   <int> <date>    
#> 1 aws     14594 2019-07-22
#> 2 cran    14594 2019-07-22
#> 3 private 14594 2019-07-22
#> 4 curtin  14594 2019-07-21
#> 5 aarnet  14569 2019-07-15
#> 6 csiro   14569 2019-07-15
#> 7 unimelb 14567 2019-07-15
```

-----

Please note that the ‘ozcran’ project is released with a [Contributor
Code of Conduct](https://CODE_OF_CONDUCT.md). By contributing to this
project, you agree to abide by its terms.
