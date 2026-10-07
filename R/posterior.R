.sears2_beta_difference <- function(s_d, n_d, s_k, n_k, margin, prior) {
  vals <- c(s_d, n_d, s_k, n_k, margin, prior)
  .sears2_check(all(is.finite(vals)) && s_d >= 0 && s_d <= n_d && s_k >= 0 && s_k <= n_k,
                "invalid posterior count input")
  .sears2_check(length(prior) == 2L && all(prior > 0), "prior must have two positive beta shapes")
  stats::integrate(function(x) {
    stats::dbeta(x, s_d + prior[1], n_d - s_d + prior[2]) *
      stats::pbeta(pmin(1, pmax(0, x - margin)),
                   s_k + prior[1], n_k - s_k + prior[2])
  }, 0, 1, rel.tol = 1e-8, subdivisions = 1000L)$value
}

sears2_relations <- function(activity_successes, activity_n,
                             tolerability_failures, tolerability_n,
                             design = sears2_design(), prior = design$comparative_prior) {
  .sears2_check(inherits(design, "sears2_design"), "design must be a sears2_design object")
  .sears2_named_numeric(activity_successes, "activity_successes", TRUE)
  .sears2_named_numeric(activity_n, "activity_n", TRUE)
  .sears2_named_numeric(tolerability_failures, "tolerability_failures", TRUE)
  .sears2_named_numeric(tolerability_n, "tolerability_n", TRUE)
  .sears2_check(.sears2_same_names(activity_successes, activity_n, tolerability_failures, tolerability_n),
                "all endpoint vectors must have identical dose names and order")
  .sears2_check(all(activity_successes <= activity_n), "activity successes cannot exceed n")
  .sears2_check(all(tolerability_failures <= tolerability_n), "tolerability failures cannot exceed n")
  doses <- names(activity_n)
  blank <- matrix(0, length(doses), length(doses), dimnames = list(doses, doses))
  acceptable <- superior <- tolerability <- blank
  for (d in doses) for (k in setdiff(doses, d)) {
    acceptable[d, k] <- .sears2_beta_difference(
      activity_successes[d], activity_n[d], activity_successes[k], activity_n[k],
      -design$delta_E, prior)
    superior[d, k] <- .sears2_beta_difference(
      activity_successes[d], activity_n[d], activity_successes[k], activity_n[k],
      design$delta_E, prior)
    tolerability[d, k] <- .sears2_beta_difference(
      tolerability_failures[k], tolerability_n[k], tolerability_failures[d], tolerability_n[d],
      design$delta_T, prior)
  }
  structure(list(
    acceptable = acceptable, superior = superior, tolerability = tolerability,
    activity_n = activity_n, tolerability_n = tolerability_n, prior = prior
  ), class = "sears2_relations")
}
