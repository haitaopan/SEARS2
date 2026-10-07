test_that("paper defaults are frozen", {
  d <- sears2_design()
  expect_s3_class(d, "sears2_design")
  expect_equal(d$pT, 0.17)
  expect_equal(d$delta_E, 0.08)
  expect_equal(d$delta_T, 0.10)
  expect_equal(c(d$gamma_A, d$gamma_T, d$gamma_S), c(0.70, 0.90, 0.85))
  expect_equal(c(d$activity_maturity, d$tolerability_maturity, d$final_n_per_arm),
               c(12L, 18L, 36L))
})

test_that("invalid design inputs fail", {
  expect_error(sears2_design(gamma_S = 1.2))
  expect_error(sears2_design(activity_maturity = 40L))
  expect_error(sears2_design(exposure_window = c(1, 0.5)))
})
