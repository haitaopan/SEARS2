test_that("four-state mapping works", {
  ready <- c(range=TRUE, activity=TRUE, tolerability=TRUE,
             required_model_evidence_ready=TRUE, conflict=TRUE)
  one <- matrix(FALSE, 1, 1, dimnames=list("D2","D2"))
  x <- sears2_decision(c(D2=TRUE), one, ready)
  expect_equal(x$final_state, "SELECT_ONE")
  expect_equal(x$selected_dose, "D2")

  two <- matrix(FALSE, 2, 2, dimnames=list(c("D2","D3"),c("D2","D3")))
  x <- sears2_decision(c(D2=TRUE,D3=TRUE), two, ready)
  expect_equal(x$final_state, "RETAIN_SET")

  x <- sears2_decision(c(D2=FALSE,D3=FALSE), two, ready)
  expect_equal(x$final_state, "NO_ACCEPTABLE_DOSE")

  not_ready <- ready; not_ready["activity"] <- FALSE
  x <- sears2_decision(c(D2=TRUE,D3=TRUE), two, not_ready)
  expect_equal(x$final_state, "DEFER")
})

test_that("cyclic dominance defers", {
  ready <- c(range=TRUE, activity=TRUE, tolerability=TRUE,
             required_model_evidence_ready=TRUE, conflict=TRUE)
  cyc <- matrix(c(FALSE,TRUE,TRUE,FALSE),2,2,byrow=TRUE,
                dimnames=list(c("D2","D3"),c("D2","D3")))
  x <- sears2_decision(c(D2=TRUE,D3=TRUE), cyc, ready)
  expect_equal(x$final_state, "DEFER")
  expect_equal(x$reason, "contradictory_dominance")
})
