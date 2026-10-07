test_that("safety action is ordered and restrictive", {
  d <- sears2_design()
  x <- sears2_safety_action(
    n=c(D1=3,D2=0,D3=0,D4=0), dlt=c(D1=0,D2=0,D3=0,D4=0),
    current_dose="D1", design=d)
  expect_equal(x$action, "ESCALATE")
  expect_equal(x$next_dose, "D2")
})

test_that("high posterior toxicity can eliminate dose and above", {
  d <- sears2_design()
  x <- sears2_safety_action(
    n=c(D1=3,D2=3,D3=0,D4=0), dlt=c(D1=0,D2=3,D3=0,D4=0),
    current_dose="D2", design=d)
  expect_true(x$eliminated["D2"])
  expect_true(x$eliminated["D3"])
  expect_true(x$eliminated["D4"])
})
