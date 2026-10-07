sears2_design <- function(
  pT = 0.17, exposure_window = c(0.75, 1.35), delta_E = 0.08, delta_T = 0.10,
  gamma_A = 0.70, gamma_T = 0.90, gamma_S = 0.85,
  activity_maturity = 12L, tolerability_maturity = 18L, final_n_per_arm = 36L,
  cohort_size = 3L, safety_max_n = 24L, lambda_e = 0.13356, lambda_d = 0.20258,
  safety_prior = c(1, 1), safety_elimination_probability = 0.95,
  safety_elimination_min_n = 3L, comparative_prior = c(0.5, 0.5)) {
  probs <- c(pT, gamma_A, gamma_T, gamma_S, safety_elimination_probability)
  .sears2_check(all(is.finite(probs) & probs > 0 & probs < 1), "probability parameters must lie in (0,1)")
  .sears2_check(length(exposure_window) == 2L && all(is.finite(exposure_window)) &&
                  exposure_window[1] < exposure_window[2], "invalid exposure_window")
  .sears2_check(all(is.finite(c(delta_E, delta_T))) && delta_E >= 0 && delta_T >= 0,
                "clinical margins must be non-negative")
  ints <- c(activity_maturity, tolerability_maturity, final_n_per_arm, cohort_size,
            safety_max_n, safety_elimination_min_n)
  .sears2_check(all(is.finite(ints) & ints > 0 & ints == floor(ints)),
                "sample-size/count parameters must be positive integers")
  .sears2_check(activity_maturity <= final_n_per_arm && tolerability_maturity <= final_n_per_arm,
                "maturity counts cannot exceed final_n_per_arm")
  .sears2_check(is.finite(lambda_e) && is.finite(lambda_d) && lambda_e < lambda_d,
                "lambda_e must be below lambda_d")
  .sears2_check(length(safety_prior) == 2L && all(safety_prior > 0) &&
                  length(comparative_prior) == 2L && all(comparative_prior > 0),
                "beta priors must contain two positive shape parameters")
  out <- list(
    pT = pT, exposure_window = exposure_window, delta_E = delta_E, delta_T = delta_T,
    gamma_A = gamma_A, gamma_T = gamma_T, gamma_S = gamma_S,
    activity_maturity = as.integer(activity_maturity),
    tolerability_maturity = as.integer(tolerability_maturity),
    final_n_per_arm = as.integer(final_n_per_arm), cohort_size = as.integer(cohort_size),
    safety_max_n = as.integer(safety_max_n), lambda_e = lambda_e, lambda_d = lambda_d,
    safety_prior = safety_prior, safety_elimination_probability = safety_elimination_probability,
    safety_elimination_min_n = as.integer(safety_elimination_min_n),
    comparative_prior = comparative_prior
  )
  class(out) <- "sears2_design"
  out
}
