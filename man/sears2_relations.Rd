\name{sears2_relations}
\alias{sears2_relations}
\alias{sears2_dominance}
\title{Claim-specific posterior relations and dominance}
\usage{
sears2_relations(activity_successes, activity_n, tolerability_failures,
  tolerability_n, design = sears2_design(), prior = design$comparative_prior)

sears2_dominance(relations, design = sears2_design())
}
\arguments{
\item{activity_successes}{Named vector of randomized activity successes by dose.}
\item{activity_n}{Named vector of randomized activity-evaluable counts by dose.}
\item{tolerability_failures}{Named vector of randomized tolerability failures by dose.}
\item{tolerability_n}{Named vector of randomized tolerability-evaluable counts by dose.}
\item{design}{A \code{sears2_design} object.}
\item{prior}{Length-two beta prior shape vector for comparative endpoint probabilities.}
\item{relations}{A \code{sears2_relations} object.}
}
\description{Computes posterior probabilities for activity acceptability, meaningful activity superiority, and meaningful tolerability advantage, then maps them to directed dominance paths using claim-specific thresholds.}
\value{\code{sears2_relations()} returns a \code{sears2_relations} object. \code{sears2_dominance()} returns a \code{sears2_dominance} object containing combined, activity-led, and tolerability-led adjacency matrices.}
\examples{
r <- sears2_relations(c(D2=18,D3=19), c(D2=36,D3=36),
  c(D2=5,D3=12), c(D2=36,D3=36))
sears2_dominance(r)
}
