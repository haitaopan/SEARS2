\name{sears2_safety_action}
\alias{sears2_safety_action}
\title{Apply the BOIN-style direct-safety backbone}
\usage{sears2_safety_action(n, dlt, current_dose, eliminated = NULL,
  ordered_doses = names(n), design = sears2_design())}
\arguments{
\item{n}{Named direct DLT-evaluable counts by ordered dose.}
\item{dlt}{Named DLT counts by ordered dose.}
\item{current_dose}{Current dose name.}
\item{eliminated}{Optional named logical vector of already eliminated doses.}
\item{ordered_doses}{Dose ordering; defaults to \code{names(n)}.}
\item{design}{A \code{sears2_design} object.}
}
\description{Applies the manuscript's direct pediatric DLT escalation/de-escalation and posterior elimination rules. Model evidence is not used to make safety exploration more aggressive.}
\value{A list containing the action, next dose, eliminated doses, and posterior toxicity risk.}
\examples{sears2_safety_action(c(D1=3,D2=0,D3=0,D4=0),
  c(D1=0,D2=0,D3=0,D4=0), "D1")}
