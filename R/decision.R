.sears2_readiness <- function(readiness) {
  req <- c("range", "activity", "tolerability", "required_model_evidence_ready", "conflict")
  if (is.list(readiness)) readiness <- unlist(readiness, use.names = TRUE)
  .sears2_check(is.logical(readiness) && setequal(names(readiness), req) && !anyNA(readiness),
                "readiness must provide named logical range/activity/tolerability/required_model_evidence_ready/conflict")
  readiness[req]
}

sears2_decision <- function(hard_admissible, dominance, readiness) {
  .sears2_named_logical(hard_admissible, "hard_admissible")
  readiness <- .sears2_readiness(readiness)
  if (!any(hard_admissible))
    return(structure(list(final_state = "NO_ACCEPTABLE_DOSE", selected_dose = character(),
                          retained_set = character(), reason = "no_hard_admissible_dose"),
                     class = "sears2_decision"))
  if (!all(readiness))
    return(structure(list(final_state = "DEFER", selected_dose = character(),
                          retained_set = character(), reason = "readiness_not_met"),
                     class = "sears2_decision"))
  eligible <- names(hard_admissible)[hard_admissible]
  mat <- if (inherits(dominance, "sears2_dominance")) dominance$dominance else dominance
  .sears2_check(is.matrix(mat) && is.logical(mat) && !anyNA(mat),
                "dominance must be a logical square matrix or sears2_dominance object")
  .sears2_check(setequal(rownames(mat), eligible) && setequal(colnames(mat), eligible),
                "dominance matrix must cover exactly the hard-admissible doses")
  mat <- mat[eligible, eligible, drop = FALSE]
  .sears2_check(!any(diag(mat)), "self-dominance is invalid")
  survivors <- eligible[colSums(mat) == 0L]
  if (!length(survivors))
    return(structure(list(final_state = "DEFER", selected_dose = character(),
                          retained_set = character(), reason = "contradictory_dominance"),
                     class = "sears2_decision"))
  if (length(survivors) == 1L)
    return(structure(list(final_state = "SELECT_ONE", selected_dose = survivors,
                          retained_set = character(), reason = "unique_non_dominated"),
                     class = "sears2_decision"))
  structure(list(final_state = "RETAIN_SET", selected_dose = character(),
                 retained_set = survivors, reason = "multiple_non_dominated"),
            class = "sears2_decision")
}
