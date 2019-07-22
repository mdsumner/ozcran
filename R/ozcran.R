#' Australian CRAN mirrors
#'
#' Hardcoded list of Australian mirrors
#'
#' These are by name [csiro](https://cran.csiro.au), [unimelb](https://cran.ms.unimelb.edu.au),
#' [aarnet](https://mirror.aarnet.edu.au/pub/CRAN), [curtin](https://cran.curtin.edu.au),
#' [aws](https://cloud.r-project.org).
#'
#' `aws` is a special case, the "cloud" redirect sponsored by RStudio, it redirects to a nearby Amazon
#' AWS server. I asumme this is usually Sydney, right on the big fat fibre pipes in Haymarket that many
#' companies use.
#'
#' A 'private' repository can be included by setting the environment variable 'OZ_PRIVATE'. Do not include
#' the trailing slash, as in the list above. If set this will be included like
#' `c(private = "https://mycran/")`.
#'
#' @return named vector of mirror addresses
#' @export
#' @seealso [oz_db] that returns the package list from these repositories
#' @examples
#' oz_repos()
oz_repos <- function() {
  c(c(csiro = "https://cran.csiro.au"
    , unimelb = "https://cran.ms.unimelb.edu.au"
    , aarnet = "https://mirror.aarnet.edu.au/pub/CRAN"
    , curtin = "https://cran.curtin.edu.au"
    , aws = "https://cloud.r-project.org"),
  oz_private())
}

# internal function to get the private repository from envvar
oz_private <- function() {
  x <- Sys.getenv("OZ_PRIVATE")
  if (nchar(x) > 0) {
    x <- c(private = x)
  }
  x[nchar(x) > 0]
}

#' Australian CRAN mirrors
#'
#' Database of packages from Australian CRAN mirrors
#'
#'  The data returned is from [tools::CRAN_package_db()] and not [utils::available.packages()], but with the
#' duplicated "MD5Sums" column removed (which breaks tibble/dplyr.) There is an added column `repos` which
#' is the name for the address provided above.
#'
#' @param ... dots, ignored
#'
#' @return data frame of packages from each repository
#' @export
#' @seealso [oz_repos()] for the list of mirrors used
#' @examples
#' library(dplyr)
#' oz_db() %>% group_by(repos) %>%
#' summarize(n = n(), date = max(as.Date(Published), na.rm = TRUE)) %>%
#' arrange(desc(date))
oz_db <- function(...) {
  env0 <- Sys.getenv("R_CRAN_WEB")
  on.exit(if (!is.null(env0)) {Sys.setenv(R_CRAN_WEB = env0)} else {Sys.unsetenv("R_CRAN_WEB")}, add = TRUE)
  repos <- oz_repos()
  purrr::map2_dfr(repos, names(repos), ~{
    Sys.setenv(R_CRAN_WEB = .x)
    db <- try(suppressWarnings(rawdb <- tools::CRAN_package_db()), silent = TRUE)
    if (inherits(db, "try-error")) return(NULL)
    rawdb$MD5sum <- NULL
    dplyr::mutate(tibble::as_tibble(rawdb ),
                  repos = .y)
    })
}
