.sears2_truth_from_input <- function(truth, strategy, design) {
  if (is.character(truth) && length(truth) == 1L) {
    x <- sears2_paper_scenarios[sears2_paper_scenarios$scenario_id == truth, , drop = FALSE]
    .sears2_check(nrow(x) == 4L, "unknown paper scenario_id")
    x$activity <- (1 - x$pi_true) * x$q_R + x$pi_true * x$q_V
    x$tolerability_failure <- (1 - x$pi_true) * x$r_R + x$pi_true * x$r_V
    x$model_activity <- (1 - x$pi_model) * x$q_R + x$pi_model * x$q_V
    candidates <- if (strategy == "direct_only") c("D1","D2","D3") else c("D2","D3")
    return(x[x$dose %in% candidates, c("dose","dlt","exposure","activity",
                                       "tolerability_failure","model_activity"), drop = FALSE])
  }
  .sears2_check(is.data.frame(truth), "truth must be a paper scenario_id or data.frame")
  req <- c("dose", "activity", "tolerability_failure")
  .sears2_check(all(req %in% names(truth)), "truth data.frame must contain dose/activity/tolerability_failure")
  .sears2_check(!anyDuplicated(truth$dose) && all(nzchar(truth$dose)), "truth dose names must be unique")
  .sears2_check(all(truth$activity >= 0 & truth$activity <= 1) &&
                  all(truth$tolerability_failure >= 0 & truth$tolerability_failure <= 1),
                "truth probabilities must lie in [0,1]")
  truth
}

simulate_sears2_trial <- function(truth, strategy = c("sears2", "static_model", "direct_only"),
                                  design = sears2_design(), n_per_arm = design$final_n_per_arm,
                                  seed = NULL, hard_admissible = NULL, model_qualified = TRUE) {
  strategy <- .sears2_match_strategy(strategy)
  .sears2_check(length(n_per_arm) == 1L && is.finite(n_per_arm) &&
                  n_per_arm > 0 && n_per_arm == floor(n_per_arm),
                "n_per_arm must be a positive integer")
  dat <- .sears2_truth_from_input(truth, strategy, design)
  doses <- dat$dose
  if (is.null(hard_admissible)) {
    hard_admissible <- if ("dlt" %in% names(dat))
      setNames(dat$dlt <= design$pT, doses) else setNames(rep(TRUE, length(doses)), doses)
  }
  .sears2_named_logical(hard_admissible, "hard_admissible")
  .sears2_check(identical(names(hard_admissible), doses), "hard_admissible must match truth dose order")
  generated <- .sears2_with_seed(seed, {
    a <- stats::rbinom(length(doses), n_per_arm, dat$activity)
    r <- stats::rbinom(length(doses), n_per_arm, dat$tolerability_failure)
    list(activity = setNames(a, doses), tolerability = setNames(r, doses))
  })
  model_activity <- if ("model_activity" %in% names(dat)) setNames(dat$model_activity, doses) else NULL
  if (strategy == "static_model" && is.null(model_activity))
    stop("static_model simulation requires model_activity in truth", call. = FALSE)
  fit <- sears2_analyze(
    design = design, strategy = strategy,
    activity_successes = generated$activity, activity_n = setNames(rep(n_per_arm,length(doses)),doses),
    tolerability_failures = generated$tolerability, tolerability_n = setNames(rep(n_per_arm,length(doses)),doses),
    hard_admissible = hard_admissible, model_activity = model_activity,
    model_qualified = model_qualified
  )
  out <- list(scope = "comparative_stage_only", seed = seed, truth = dat,
              activity_successes = generated$activity, tolerability_failures = generated$tolerability,
              analysis = fit)
  class(out) <- "sears2_simulated_trial"
  out
}

simulate_sears2_oc <- function(truth, nsim = 100L, seed = 1L,
                               strategy = c("sears2", "static_model", "direct_only"),
                               design = sears2_design(), n_per_arm = design$final_n_per_arm) {
  strategy <- .sears2_match_strategy(strategy)
  .sears2_check(length(nsim) == 1L && nsim > 0 && nsim == floor(nsim),
                "nsim must be a positive integer")
  seeds <- as.integer(seed) + seq_len(nsim) - 1L
  trials <- lapply(seeds, function(s) simulate_sears2_trial(
    truth = truth, strategy = strategy, design = design, n_per_arm = n_per_arm, seed = s))
  states <- vapply(trials, function(x) x$analysis$decision$final_state, character(1))
  selected <- vapply(trials, function(x) {
    z <- x$analysis$decision$selected_dose
    if (length(z)) z else ""
  }, character(1))
  retained <- vapply(trials, function(x) paste(x$analysis$decision$retained_set, collapse = ";"), character(1))
  list(
    scope = "comparative_stage_only", strategy = strategy, nsim = as.integer(nsim),
    state_probabilities = sort(table(states) / nsim, decreasing = TRUE),
    selected_dose_probabilities = sort(table(selected[selected != ""]) / nsim, decreasing = TRUE),
    retained_set_probabilities = sort(table(retained[retained != ""]) / nsim, decreasing = TRUE),
    trials = trials
  )
}
