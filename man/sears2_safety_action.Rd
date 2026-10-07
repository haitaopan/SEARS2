\name{sears2_safety_action}
\alias{sears2_safety_action}
\title{Apply the BOIN-style direct-safety backbone}
\usage{sears2_safety_action(n, dlt, current_dose, eliminated = NULL,
  ordered_doses = names(n), design = sears2_design())}
\description{Applies the manuscript's direct pediatric DLT escalation/de-escalation and posterior elimination rules. Model evidence is not used to make safety exploration more aggressive.}
\value{A list containing the action, next dose, eliminated doses, and posterior toxicity risk.}
\examples{sears2_safety_action(c(D1=3,D2=0,D3=0,D4=0),
  c(D1=0,D2=0,D3=0,D4=0), "D1")}
