sears2_safety_action <- function(n, dlt, current_dose, eliminated = NULL,
                                 ordered_doses = names(n), design = sears2_design()) {
  .sears2_named_numeric(n, "n", TRUE)
  .sears2_named_numeric(dlt, "dlt", TRUE)
  .sears2_check(identical(names(n), names(dlt)), "n and dlt must have identical names/order")
  .sears2_check(all(dlt <= n), "dlt cannot exceed n")
  .sears2_check(identical(ordered_doses, names(n)), "ordered_doses must match n order")
  .sears2_check(current_dose %in% ordered_doses, "unknown current_dose")
  if (is.null(eliminated)) eliminated <- setNames(rep(FALSE, length(n)), ordered_doses)
  .sears2_named_logical(eliminated, "eliminated")
  .sears2_check(identical(names(eliminated), ordered_doses), "eliminated order mismatch")
  risk <- stats::pbeta(design$pT, dlt + design$safety_prior[1],
                       n - dlt + design$safety_prior[2], lower.tail = FALSE)
  newly <- which(n >= design$safety_elimination_min_n &
                 risk > design$safety_elimination_probability)
  if (length(newly)) eliminated[min(newly):length(eliminated)] <- TRUE
  i <- match(current_dose, ordered_doses)
  if (eliminated[1L]) return(list(action = "TERMINATE", next_dose = NA_character_,
                                   eliminated = eliminated, posterior_risk = risk))
  if (eliminated[i]) {
    below <- which(!eliminated & seq_along(eliminated) < i)
    next_i <- max(below); action <- "ELIMINATE"
  } else if (n[i] == 0L) {
    next_i <- i; action <- "STAY"
  } else if (dlt[i] / n[i] <= design$lambda_e && i < length(n) && !eliminated[i + 1L]) {
    next_i <- i + 1L; action <- "ESCALATE"
  } else if (dlt[i] / n[i] >= design$lambda_d && i > 1L) {
    next_i <- i - 1L; action <- "DEESCALATE"
  } else {
    next_i <- i; action <- "STAY"
  }
  list(action = action, next_dose = ordered_doses[next_i],
       eliminated = eliminated, posterior_risk = risk)
}
