# shiny-deseq2 tests
# ==================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

library(testthat)
library(shinytest)

test_that("all systems nominal", {
  # by default runs all scripts in ./tests/
  expect_pass(testApp(".", compareImages = FALSE))
})