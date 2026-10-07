.sears2_static_gate <- function(model_activity, delta_E) {
  .sears2_named_numeric(model_activity, "model_activity", FALSE)
  .sears2_check(all(model_activity >= 0 & model_activity <= 1), "model_activity must lie in [0,1]")
  model_activity >= max(model_activity) - delta_E
}

sears2_analyze <- function(design = sears2_design(),
                           strategy = c("sears2", "static_model", "direct_only"),
                           activity_successes, activity_n,
                           tolerability_failures, tolerability_n,
                           hard_admissible, model_activity = NULL,
                           model_qualified = TRUE, overlapping = TRUE,
                           required_model_evidence_ready = TRUE, conflict_ok = TRUE) {
  strategy <- .sears2_match_strategy(strategy)
  .sears2_check(inherits(design, "sears2_design"), "design must be a sears2_design object")
  .sears2_named_logical(hard_admissible, "hard_admissible")
  doses <- names(activity_n)
  .sears2_check(identical(names(hard_admissible), doses),
                "hard_admissible must have the same dose names/order as activity_n")
  flags <- c(model_qualified, overlapping, required_model_evidence_ready, conflict_ok)
  .sears2_check(is.logical(flags) && length(flags) == 4L && !anyNA(flags),
                "model/readiness flags must be scalar logical values")
  if (strategy == "static_model" && !model_qualified)
    required_model_evidence_ready <- FALSE
  relations <- sears2_relations(activity_successes, activity_n,
                                tolerability_failures, tolerability_n, design)
  activity_mature <- all(activity_n >= design$activity_maturity)
  tolerability_mature <- all(tolerability_n >= design$tolerability_maturity)
  authority <- sears2_authority(strategy, activity_mature, overlapping, model_qualified)
  eligible <- hard_admissible
  model_gate <- setNames(rep(TRUE, length(eligible)), names(eligible))
  if (strategy == "static_model" && model_qualified) {
    .sears2_check(!is.null(model_activity), "static_model requires model_activity when model_qualified=TRUE")
    .sears2_named_numeric(model_activity, "model_activity", FALSE)
    .sears2_check(identical(names(model_activity), names(eligible)),
                  "model_activity must match candidate dose names/order")
    active <- names(eligible)[eligible]
    if (length(active)) {
      model_gate[active] <- .sears2_static_gate(model_activity[active], design$delta_E)
      eligible[active] <- model_gate[active]
    }
  }
  keep <- names(eligible)[eligible]
  if (length(keep)) {
    rel_keep <- structure(list(
      acceptable = .sears2_subset_square(relations$acceptable, keep),
      superior = .sears2_subset_square(relations$superior, keep),
      tolerability = .sears2_subset_square(relations$tolerability, keep),
      activity_n = activity_n[keep], tolerability_n = tolerability_n[keep],
      prior = relations$prior
    ), class = "sears2_relations")
    dom <- sears2_dominance(rel_keep, design)
  } else {
    z <- matrix(FALSE, 0L, 0L, dimnames = list(character(), character()))
    dom <- structure(list(dominance = z, activity_led = z, tolerability_led = z,
                          thresholds = c(gamma_A = design$gamma_A, gamma_T = design$gamma_T,
                                         gamma_S = design$gamma_S)),
                     class = "sears2_dominance")
  }
  readiness <- c(
    range = TRUE, activity = activity_mature, tolerability = tolerability_mature,
    required_model_evidence_ready = required_model_evidence_ready, conflict = conflict_ok
  )
  decision <- sears2_decision(eligible, dom, readiness)
  out <- list(
    strategy = strategy, design = design, authority = authority, relations = relations,
    dominance = dom, hard_admissible = hard_admissible, model_gate = model_gate,
    final_eligible = eligible, readiness = readiness, decision = decision
  )
  class(out) <- "sears2_result"
  out
}
