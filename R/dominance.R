sears2_dominance <- function(relations, design = sears2_design()) {
  .sears2_check(inherits(relations, "sears2_relations"), "relations must come from sears2_relations()")
  .sears2_check(inherits(design, "sears2_design"), "design must be a sears2_design object")
  activity_led <- relations$superior >= design$gamma_S
  tolerability_led <- relations$acceptable >= design$gamma_A &
    relations$tolerability >= design$gamma_T
  dominance <- activity_led | tolerability_led
  diag(activity_led) <- diag(tolerability_led) <- diag(dominance) <- FALSE
  structure(list(
    dominance = dominance, activity_led = activity_led, tolerability_led = tolerability_led,
    thresholds = c(gamma_A = design$gamma_A, gamma_T = design$gamma_T, gamma_S = design$gamma_S)
  ), class = "sears2_dominance")
}
