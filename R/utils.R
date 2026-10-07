.sears2_check <- function(ok, message) {
  if (!isTRUE(ok)) stop(message, call. = FALSE)
}

.sears2_match_strategy <- function(strategy) {
  match.arg(strategy, c("sears2", "static_model", "direct_only"))
}

.sears2_named_numeric <- function(x, what, integerish = FALSE) {
  .sears2_check(is.numeric(x) && length(x) >= 1L && !is.null(names(x)),
                paste0(what, " must be a named numeric vector"))
  .sears2_check(!anyDuplicated(names(x)) && all(nzchar(names(x))),
                paste0(what, " names must be unique and non-empty"))
  .sears2_check(all(is.finite(x)), paste0(what, " must be finite"))
  if (integerish) .sears2_check(all(x >= 0 & x == floor(x)),
                                 paste0(what, " must be non-negative integers"))
  invisible(TRUE)
}

.sears2_named_logical <- function(x, what) {
  .sears2_check(is.logical(x) && length(x) >= 1L && !is.null(names(x)) && !anyNA(x),
                paste0(what, " must be a named logical vector without NA"))
  .sears2_check(!anyDuplicated(names(x)) && all(nzchar(names(x))),
                paste0(what, " names must be unique and non-empty"))
  invisible(TRUE)
}

.sears2_same_names <- function(...) {
  xs <- list(...)
  ref <- names(xs[[1L]])
  all(vapply(xs[-1L], function(x) identical(names(x), ref), logical(1)))
}

.sears2_subset_square <- function(x, keep) {
  x[keep, keep, drop = FALSE]
}

.sears2_with_seed <- function(seed, expr) {
  if (is.null(seed)) return(force(expr))
  .sears2_check(length(seed) == 1L && is.finite(seed), "seed must be one finite value")
  had_seed <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  if (had_seed) old_seed <- get(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  on.exit({
    if (had_seed) assign(".Random.seed", old_seed, envir = .GlobalEnv)
    else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE))
      rm(".Random.seed", envir = .GlobalEnv)
  }, add = TRUE)
  set.seed(as.integer(seed))
  force(expr)
}
