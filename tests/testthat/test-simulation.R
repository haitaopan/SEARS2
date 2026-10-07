test_that("comparative-stage simulation is seed reproducible", {
  a <- simulate_sears2_trial("C1-M2", strategy="sears2", seed=1001)
  b <- simulate_sears2_trial("C1-M2", strategy="sears2", seed=1001)
  expect_identical(a$activity_successes, b$activity_successes)
  expect_identical(a$tolerability_failures, b$tolerability_failures)
  expect_equal(a$analysis$decision, b$analysis$decision)
})

test_that("paper data are present", {
  expect_equal(nrow(sears2_paper_scenarios), 48L)
  expect_equal(nrow(sears2_paper_truth), 12L)
  expect_equal(sears2_paper_truth$optimized[sears2_paper_truth$scenario_id=="C1-M2"], "D2")
})
