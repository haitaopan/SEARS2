print.sears2_design <- function(x, ...) {
  cat("SEARS 2.0 design\n")
  cat("  pT:", x$pT, "\n")
  cat("  margins: delta_E =", x$delta_E, ", delta_T =", x$delta_T, "\n")
  cat("  thresholds: gamma_A =", x$gamma_A, ", gamma_T =", x$gamma_T,
      ", gamma_S =", x$gamma_S, "\n")
  cat("  maturity per arm: activity =", x$activity_maturity,
      ", tolerability =", x$tolerability_maturity, "\n")
  cat("  terminal randomized N/arm:", x$final_n_per_arm, "\n")
  invisible(x)
}

summary.sears2_design <- function(object, ...) {
  unclass(object)
}

print.sears2_result <- function(x, ...) {
  cat("SEARS 2.0 analysis\n")
  cat("  strategy:", x$strategy, "\n")
  cat("  model role:", x$authority$model_role, "\n")
  cat("  final state:", x$decision$final_state, "\n")
  if (length(x$decision$selected_dose))
    cat("  selected dose:", x$decision$selected_dose, "\n")
  if (length(x$decision$retained_set))
    cat("  retained set:", paste(x$decision$retained_set, collapse = ", "), "\n")
  cat("  reason:", x$decision$reason, "\n")
  invisible(x)
}

summary.sears2_result <- function(object, ...) {
  list(
    strategy = object$strategy, authority = object$authority, readiness = object$readiness,
    final_eligible = names(object$final_eligible)[object$final_eligible],
    decision = object$decision, relations = object$relations, dominance = object$dominance
  )
}
