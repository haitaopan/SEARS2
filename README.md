# SEARS2

**SEARS 2.0: Decision-Specific Evidence Authority for Dose Optimization**

SEARS 2.0 is a research-software implementation of an evidence-to-dose-decision
framework for early-phase dose optimization. A central principle is that evidence
that is fit for early screening need not retain the same authority at final dose
selection. The package separates direct safety, model-informed shortlisting,
maturity-gated randomized evidence, claim-specific posterior evidence, and four
possible final actions.

> **Research software.** The paper defaults are design-study values and are not
> universal clinical constants, validated clinical decision rules, or regulatory
> qualification.

## Installation

```r
# install.packages("remotes")
remotes::install_github("haitaopan/SEARS2")
```

## 30-second example

```r
library(SEARS2)

design <- sears2_design()

activity_n <- c(D2 = 36, D3 = 36)
activity_successes <- c(D2 = 18, D3 = 18)
tolerability_n <- c(D2 = 36, D3 = 36)
tolerability_failures <- c(D2 = 4, D3 = 14)

fit <- sears2_analyze(
  design = design,
  strategy = "sears2",
  activity_successes = activity_successes,
  activity_n = activity_n,
  tolerability_failures = tolerability_failures,
  tolerability_n = tolerability_n,
  hard_admissible = c(D2 = TRUE, D3 = TRUE),
  model_activity = c(D2 = 0.48, D3 = 0.59),
  model_qualified = TRUE
)

fit
```

The result is one of four final states:

- `SELECT_ONE`
- `RETAIN_SET`
- `NO_ACCEPTABLE_DOSE`
- `DEFER`

## The authority transition

`static_model` retains the model activity gate at final selection.
`sears2` uses the same model-informed shortlist but, after mature overlapping
direct evidence is available, the model role becomes contextual `Support` rather
than a quantitative veto. No pseudo-data borrowing is used in the primary
implementation.

## Paper defaults

```r
sears2_paper_defaults
sears2_paper_truth
head(sears2_paper_scenarios)
```

## Software status

Version 0.1.0 is the initial GitHub implementation accompanying the SEARS 2.0
manuscript under external scientific review. The package API may evolve before a
future CRAN submission.

## SEARS 1.0 and SEARS 2.0

SEARS 1.0 focused on seamless statistical decision mechanics. SEARS 2.0 focuses
on which evidence is allowed to influence which dose decision, at what authority,
and under what maturity/applicability conditions.

## Citation

A formal `CITATION` entry will be added when the manuscript bibliographic record is
stable. Until then, please cite the SEARS 2.0 manuscript and this GitHub repository.
