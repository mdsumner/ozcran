oz_repos <- function() {
  c(c(csiro = "https://cran.csiro.au/"
    , unimelb = "https://cran.ms.unimelb.edu.au/"
    , aarnet = "https://mirror.aarnet.edu.au/pub/CRAN/"
    , curtin = "https://cran.curtin.edu.au/"
    , aws = "https://cloud.r-project.org/"),
  oz_private())
}

oz_private <- function() {
  x <- Sys.getenv("oz_private")
  if (nchar(x) > 0) {
    x <- c(private = x)
  }
  x
}

oz_db <- function(...) {
  env0 <- Sys.getenv("R_CRAN_WEB")
  on.exit(if (!is.null(env0)) {Sys.setenv(R_CRAN_WEB = env0)} else {Sys.unsetenv("R_CRAN_WEB")}, add = TRUE)
  repos <- oz_repos()
  purrr::map2_dfr(repos, names(repos), ~{
    Sys.setenv(R_CRAN_WEB = .x)
    rawdb <- tools::CRAN_package_db()
    rawdb$MD5sum <- NULL
    dplyr::mutate(tibble::as_tibble(rawdb ),
                  repos = .y)
    })
}
