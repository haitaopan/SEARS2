sears2_authority <- function(strategy = c("sears2", "static_model", "direct_only"),
                             direct_mature, overlapping = TRUE, model_qualified = TRUE) {
  strategy <- .sears2_match_strategy(strategy)
  flags <- c(direct_mature, overlapping, model_qualified)
  .sears2_check(is.logical(flags) && length(flags) == 3L && !anyNA(flags),
                "direct_mature, overlapping, and model_qualified must be scalar logical values")
  model_role <- if (strategy == "direct_only" || !model_qualified) {
    "None"
  } else if (strategy == "sears2" && direct_mature && overlapping) {
    "Support"
  } else {
    "Gate"
  }
  structure(list(
    strategy = strategy, model_role = model_role,
    direct_role = if (direct_mature) "Dominant-decide" else "Pending",
    scope = if (overlapping) "overlapping_claim" else "complementary_claim",
    prerequisites = list(model_qualified = model_qualified, direct_claim_mature = direct_mature),
    model_override_permitted = identical(strategy, "static_model") && identical(model_role, "Gate"),
    quantitative_model_contribution = FALSE
  ), class = "sears2_authority")
}
