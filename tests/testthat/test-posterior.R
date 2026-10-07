test_that("posterior relations are bounded and directional", {
  d <- sears2_design()
  r <- sears2_relations(
    activity_successes=c(D2=18,D3=19), activity_n=c(D2=36,D3=36),
    tolerability_failures=c(D2=5,D3=12), tolerability_n=c(D2=36,D3=36), design=d)
  expect_s3_class(r, "sears2_relations")
  expect_true(all(r$acceptable >= 0 & r$acceptable <= 1))
  expect_true(all(r$superior >= 0 & r$superior <= 1))
  expect_true(all(r$tolerability >= 0 & r$tolerability <= 1))
  expect_gt(r$tolerability["D2","D3"], r$tolerability["D3","D2"])
})

test_that("dominance exposes separate paths", {
  d <- sears2_design()
  r <- sears2_relations(c(D2=18,D3=19),c(D2=36,D3=36),
                        c(D2=5,D3=12),c(D2=36,D3=36),d)
  g <- sears2_dominance(r,d)
  expect_s3_class(g, "sears2_dominance")
  expect_true(is.logical(g$activity_led))
  expect_true(is.logical(g$tolerability_led))
})
