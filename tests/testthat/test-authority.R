test_that("SEARS2 authority transitions Gate to Support", {
  pre <- sears2_authority("sears2", direct_mature = FALSE, overlapping = TRUE, model_qualified = TRUE)
  post <- sears2_authority("sears2", direct_mature = TRUE, overlapping = TRUE, model_qualified = TRUE)
  expect_equal(pre$model_role, "Gate")
  expect_equal(post$model_role, "Support")
  expect_false(post$model_override_permitted)
  expect_false(post$quantitative_model_contribution)
})

test_that("static model retains Gate", {
  x <- sears2_authority("static_model", direct_mature = TRUE, overlapping = TRUE, model_qualified = TRUE)
  expect_equal(x$model_role, "Gate")
  expect_true(x$model_override_permitted)
})

test_that("direct-only has no model role", {
  x <- sears2_authority("direct_only", direct_mature = TRUE, overlapping = TRUE, model_qualified = TRUE)
  expect_equal(x$model_role, "None")
})
