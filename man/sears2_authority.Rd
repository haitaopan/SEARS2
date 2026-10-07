\name{sears2_authority}
\alias{sears2_authority}
\title{Evaluate decision-specific model authority}
\usage{sears2_authority(strategy = c("sears2", "static_model", "direct_only"),
  direct_mature, overlapping = TRUE, model_qualified = TRUE)}
\arguments{
\item{strategy}{One of \code{"sears2"}, \code{"static_model"}, or \code{"direct_only"}.}
\item{direct_mature}{Logical; whether the overlapping direct claim is mature.}
\item{overlapping}{Logical; whether model and direct evidence address the same claim.}
\item{model_qualified}{Logical; whether the model is qualified for the stated use.}
}
\description{Returns the permitted model and direct-evidence roles for a specified claim. In the primary SEARS 2.0 implementation, a mature overlapping direct claim changes the model role from Gate to contextual Support.}
\value{A list describing model role, direct role, scope, prerequisites, and whether model override is permitted.}
\examples{sears2_authority("sears2", TRUE, TRUE, TRUE)}
