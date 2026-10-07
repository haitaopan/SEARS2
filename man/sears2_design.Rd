\name{sears2_design}
\alias{sears2_design}
\title{Construct a SEARS 2.0 design specification}
\usage{
sears2_design(pT = 0.17, exposure_window = c(0.75, 1.35),
  delta_E = 0.08, delta_T = 0.10, gamma_A = 0.70, gamma_T = 0.90,
  gamma_S = 0.85, activity_maturity = 12L, tolerability_maturity = 18L,
  final_n_per_arm = 36L, cohort_size = 3L, safety_max_n = 24L,
  lambda_e = 0.13356, lambda_d = 0.20258, safety_prior = c(1, 1),
  safety_elimination_probability = 0.95, safety_elimination_min_n = 3L,
  comparative_prior = c(0.5, 0.5))
}
\arguments{
\item{pT}{Target acute DLT probability.}
\item{exposure_window}{Length-two pharmacologic exposure window.}
\item{delta_E}{Clinical activity margin.}
\item{delta_T}{Clinical tolerability-failure margin.}
\item{gamma_A}{Posterior threshold for activity adequacy/acceptability.}
\item{gamma_T}{Posterior threshold for meaningful tolerability advantage.}
\item{gamma_S}{Posterior threshold for meaningful activity superiority.}
\item{activity_maturity}{Randomized evaluable count per arm required for activity maturity.}
\item{tolerability_maturity}{Randomized evaluable count per arm required for tolerability maturity.}
\item{final_n_per_arm}{Terminal comparative information cap per arm.}
\item{cohort_size}{Safety-stage cohort size.}
\item{safety_max_n}{Maximum pre-randomization safety-stage sample size.}
\item{lambda_e}{BOIN-style escalation boundary.}
\item{lambda_d}{BOIN-style de-escalation boundary.}
\item{safety_prior}{Beta prior shapes for acute DLT probability.}
\item{safety_elimination_probability}{Posterior probability threshold for toxicity elimination.}
\item{safety_elimination_min_n}{Minimum direct DLT-evaluable count before elimination.}
\item{comparative_prior}{Beta prior shapes for randomized activity/tolerability probabilities.}
}
\description{Creates and validates a classed SEARS 2.0 design object. Defaults reproduce the frozen manuscript design and are examples rather than universal clinical constants.}
\value{An object of class \code{sears2_design}.}
\examples{d <- sears2_design(); d}
