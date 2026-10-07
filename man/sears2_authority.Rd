\name{sears2_authority}
\alias{sears2_authority}
\title{Evaluate decision-specific model authority}
\usage{sears2_authority(strategy = c("sears2", "static_model", "direct_only"),
  direct_mature, overlapping = TRUE, model_qualified = TRUE)}
\description{Returns the permitted model and direct-evidence roles for a specified claim. In the primary SEARS 2.0 implementation, a mature overlapping direct claim changes the model role from Gate to contextual Support.}
\value{A list describing model role, direct role, scope, prerequisites, and whether model override is permitted.}
\examples{sears2_authority("sears2", TRUE, TRUE, TRUE)}
