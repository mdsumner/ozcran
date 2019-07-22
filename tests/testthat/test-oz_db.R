test_that("db getting works", {
  repos <- expect_type(oz_repos(), "character")
  db <- expect_silent(oz_db())
  expect_true(nrow(db) > 70000)

})

test_that("db private setting works", {
  Sys.setenv(OZ_PRIVATE = "rupert.rabbit")
  expect_length(oz_repos(), 6L)

  Sys.unsetenv("OZ_PRIVATE")
  expect_length(oz_repos(), 5L)

})
