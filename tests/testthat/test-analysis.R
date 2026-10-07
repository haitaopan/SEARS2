test_that("static model can retain a final veto while SEARS2 removes it", {
  args <- list(
    activity_successes=c(D2=18,D3=19), activity_n=c(D2=36,D3=36),
    tolerability_failures=c(D2=5,D3=12), tolerability_n=c(D2=36,D3=36),
    hard_admissible=c(D2=TRUE,D3=TRUE), model_activity=c(D2=.30,D3=.60)
  )
  s <- do.call(sears2_analyze, c(list(strategy="sears2"), args))
  b <- do.call(sears2_analyze, c(list(strategy="static_model"), args))
  expect_equal(s$authority$model_role, "Support")
  expect_equal(b$authority$model_role, "Gate")
  expect_true(s$final_eligible["D2"])
  expect_false(b$final_eligible["D2"])
  expect_equal(b$decision$final_state, "SELECT_ONE")
  expect_equal(b$decision$selected_dose, "D3")
})

test_that("immature direct evidence defers", {
  x <- sears2_analyze(
    activity_successes=c(D2=5,D3=5), activity_n=c(D2=10,D3=10),
    tolerability_failures=c(D2=2,D3=3), tolerability_n=c(D2=10,D3=10),
    hard_admissible=c(D2=TRUE,D3=TRUE), strategy="sears2")
  expect_equal(x$decision$final_state, "DEFER")
})
