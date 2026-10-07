\name{sears2_decision}
\alias{sears2_decision}
\alias{sears2_analyze}
\title{Map evidence to a final SEARS 2.0 dose decision}
\usage{
sears2_decision(hard_admissible, dominance, readiness)

sears2_analyze(design = sears2_design(),
  strategy = c("sears2", "static_model", "direct_only"),
  activity_successes, activity_n, tolerability_failures, tolerability_n,
  hard_admissible, model_activity = NULL, model_qualified = TRUE,
  overlapping = TRUE, required_model_evidence_ready = TRUE, conflict_ok = TRUE)
}
\arguments{
\item{hard_admissible}{Named logical vector identifying doses that satisfy hard observed admissibility.}
\item{dominance}{Logical square dominance matrix or \code{sears2_dominance} object.}
\item{readiness}{Named logical vector/list with range, activity, tolerability, required model evidence, and conflict readiness.}
\item{design}{A \code{sears2_design} object.}
\item{strategy}{One of \code{"sears2"}, \code{"static_model"}, or \code{"direct_only"}.}
\item{activity_successes}{Named randomized activity success counts.}
\item{activity_n}{Named randomized activity-evaluable counts.}
\item{tolerability_failures}{Named randomized tolerability-failure counts.}
\item{tolerability_n}{Named randomized tolerability-evaluable counts.}
\item{model_activity}{Optional named model-predicted activity probabilities; required for a qualified static-model final Gate.}
\item{model_qualified}{Logical model qualification flag.}
\item{overlapping}{Logical claim-overlap flag.}
\item{required_model_evidence_ready}{Logical readiness flag for any genuinely required complementary model evidence.}
\item{conflict_ok}{Logical flag indicating no unresolved material conflict that blocks final decision.}
}
\description{Maps hard admissibility, claim-specific posterior dominance, maturity/readiness, and optional static model gating to SELECT_ONE, RETAIN_SET, NO_ACCEPTABLE_DOSE, or DEFER.}
\value{\code{sears2_decision()} returns a classed decision list. \code{sears2_analyze()} returns a \code{sears2_result} object containing authority, posterior relations, dominance, eligibility, readiness, and the final decision.}
\examples{
x <- sears2_analyze(strategy="sears2",
  activity_successes=c(D2=18,D3=19), activity_n=c(D2=36,D3=36),
  tolerability_failures=c(D2=5,D3=12), tolerability_n=c(D2=36,D3=36),
  hard_admissible=c(D2=TRUE,D3=TRUE))
x
}
