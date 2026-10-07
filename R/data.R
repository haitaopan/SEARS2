sears2_paper_defaults <- list(
  pT = 0.17, exposure_window = c(0.75, 1.35), delta_E = 0.08, delta_T = 0.10,
  gamma_A = 0.70, gamma_T = 0.90, gamma_S = 0.85,
  activity_maturity = 12L, tolerability_maturity = 18L, final_n_per_arm = 36L,
  cohort_size = 3L, safety_max_n = 24L, lambda_e = 0.13356, lambda_d = 0.20258,
  pi_model = 0.05
)

.sears2_family <- function(family, dlt, exposure, q_R, q_V, r_R, r_V) {
  data.frame(family = family, dose = paste0("D", 1:4), dlt = dlt, exposure = exposure,
             q_R = q_R, q_V = q_V, r_R = r_R, r_V = r_V, stringsAsFactors = FALSE)
}

.sears2_c1 <- .sears2_family("C1", c(.03,.06,.12,.25), c(.55,.90,1.20,1.50),
  c(.30,.48,.60,.62), c(.25,.46,.30,.25), c(.06,.12,.22,.38), c(.10,.18,.65,.80))
.sears2_c2 <- .sears2_family("C2", c(.03,.06,.12,.25), c(.55,.90,1.20,1.50),
  c(.30,.44,.62,.63), c(.25,.40,.58,.58), c(.06,.12,.20,.36), c(.10,.18,.30,.50))
.sears2_c3 <- .sears2_family("C3", c(.03,.06,.12,.25), c(.55,.90,1.20,1.50),
  c(.30,.50,.54,.55), c(.25,.47,.49,.48), c(.06,.14,.18,.32), c(.10,.20,.24,.40))
.sears2_c4 <- .sears2_family("C4", c(.22,.28,.38,.50), c(.55,.90,1.20,1.50),
  c(.55,.65,.72,.74), c(.50,.62,.68,.68), c(.10,.14,.20,.30), c(.14,.20,.30,.42))
.sears2_base <- rbind(.sears2_c1, .sears2_c2, .sears2_c3, .sears2_c4)

sears2_paper_scenarios <- do.call(rbind, lapply(c(M0=.05, M1=.15, M2=.35), function(pi) {
  x <- .sears2_base
  state <- names(c(M0=.05, M1=.15, M2=.35))[match(pi, c(.05,.15,.35))]
  x$model_state <- state
  x$pi_true <- pi
  x$pi_model <- .05
  x$scenario_id <- paste0(x$family, "-", state)
  x[, c("scenario_id","family","model_state","dose","pi_true","pi_model",
        "dlt","exposure","q_R","q_V","r_R","r_V")]
}))
rownames(sears2_paper_scenarios) <- NULL

sears2_paper_truth <- data.frame(
  scenario_id = c("C1-M0","C1-M1","C1-M2","C2-M0","C2-M1","C2-M2",
                  "C3-M0","C3-M1","C3-M2","C4-M0","C4-M1","C4-M2"),
  truth_state = c(rep("T1",6), rep("T2",3), rep("T3",3)),
  optimized = c("D3","D2","D2","D3","D3","D3",
                "D2;D3","D2;D3","D2;D3","none","none","none"),
  stringsAsFactors = FALSE
)

rm(.sears2_c1, .sears2_c2, .sears2_c3, .sears2_c4, .sears2_base)
