\name{simulate_sears2_trial}
\alias{simulate_sears2_trial}
\alias{simulate_sears2_oc}
\title{Lightweight comparative-stage SEARS 2.0 simulation}
\usage{
simulate_sears2_trial(truth, strategy = c("sears2", "static_model", "direct_only"),
  design = sears2_design(), n_per_arm = design$final_n_per_arm, seed = NULL,
  hard_admissible = NULL, model_qualified = TRUE)

simulate_sears2_oc(truth, nsim = 100L, seed = 1L,
  strategy = c("sears2", "static_model", "direct_only"),
  design = sears2_design(), n_per_arm = design$final_n_per_arm)
}
\description{Provides a lightweight final comparative-stage simulator for examples and API testing. It is not the full end-to-end manuscript production engine and does not reproduce the latent-phenotype activity/tolerability correlation or pre-randomization safety process.}
\value{\code{simulate_sears2_trial()} returns one simulated comparative-stage analysis. \code{simulate_sears2_oc()} returns simple final-state and dose-selection frequencies plus the simulated trials.}
\examples{simulate_sears2_trial("C1-M2", seed=1001)}
