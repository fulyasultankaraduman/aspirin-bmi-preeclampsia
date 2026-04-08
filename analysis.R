# ============================================================================
# Analysis Code for:
# BMI-Adjusted Aspirin Dosing Does Not Overcome Pharmacokinetic and 
# Pharmacodynamic Disadvantages in Obese Pregnant Women at Risk for 
# Preeclampsia: A Prospective Cohort Study
#
# Authors: Karaduman FS, Cim N, Caliskan M, Cim B, Yilmaz Ergani S, 
#          Yarsilikal Guleroglu F, Cetin A
# Journal: Frontiers in Medicine, 2026
# Contact: fulyasultankaraduman@gmail.com
# ============================================================================
# NOTE: Raw data not included for privacy reasons.
#       Available from corresponding author on reasonable request.
# ============================================================================

library(tidyverse)
library(effectsize)

# --- 1. Data Preparation ---
# data <- read_csv("data_anonymized.csv")
# data <- data %>%
#   mutate(
#     group_f = factor(group, levels=c(1,2), labels=c("100mg","150mg")),
#     txb2_pct = ((txb2_fu - txb2_base) / txb2_base) * 100,
#     uta_ri_pct = ((uta_ri_fu - uta_ri_base) / uta_ri_base) * 100
#   )

# --- 2. Within-Group Paired Comparisons (Primary Analyses) ---
# g1 <- data %>% filter(group == 1)
# g2 <- data %>% filter(group == 2) %>% drop_na(txb2_fu)

# TxB2 within-group (Table 2)
# t.test(g1$txb2_base, g1$txb2_fu, paired = TRUE)  # 100mg group
# t.test(g2$txb2_base, g2$txb2_fu, paired = TRUE)  # 150mg group

# Salicylate within-group (Table 2)
# t.test(g1$sal_base, g1$sal_fu, paired = TRUE)
# t.test(g2$sal_base, g2$sal_fu, paired = TRUE)

# --- 3. Descriptive Between-Group Comparisons ---
# t.test(sal_fu ~ group_f, data = data)
# cohens_d(sal_fu ~ group_f, data = data)

# --- 4. Pooled Correlation Analysis (Table 5) ---
# cor.test(data$bmi, data$sal_fu)
# cor.test(data$sal_fu, data$txb2_pct)
# cor.test(data$sal_fu, data$uta_ri_pct)
# cor.test(data$txb2_pct, data$uta_ri_pct)

# --- 5. Within-Group Correlations (Supplementary Table S1) ---
# for (grp in c(1, 2)) {
#   sub <- data %>% filter(group == grp) %>% drop_na(sal_fu, txb2_fu)
#   cat(sprintf("\n--- Group %d (n=%d) ---\n", grp, nrow(sub)))
#   print(cor.test(sub$bmi, sub$sal_fu))
#   print(cor.test(sub$sal_fu, sub$txb2_pct))
#   print(cor.test(sub$sal_fu, sub$uta_ri_pct))
#   print(cor.test(sub$txb2_pct, sub$uta_ri_pct))
# }

# --- 6. Multiple Linear Regression (Table 5) ---
# Model 1: UtA-RI percent change
# model_ri <- lm(uta_ri_pct ~ group + bmi + sal_fu, data = data)
# summary(model_ri); confint(model_ri)

# Model 2: TxB2 percent change
# model_txb2 <- lm(txb2_pct ~ group + sal_fu + txb2_base, data = data)
# summary(model_txb2); confint(model_txb2)

# --- 7. Exploratory Mediation Analysis (Supplementary) ---
# library(mediation)
# model_a <- lm(sal_fu ~ group, data = data)
# model_b <- lm(uta_ri_pct ~ group + sal_fu, data = data)
# med <- mediate(model_a, model_b, treat="group", mediator="sal_fu",
#                boot=TRUE, sims=5000)
# summary(med)

# Sobel test
# a <- coef(model_a)["group"]; b <- coef(model_b)["sal_fu"]
# se_a <- summary(model_a)$coefficients["group","Std. Error"]
# se_b <- summary(model_b)$coefficients["sal_fu","Std. Error"]
# z <- (a*b) / sqrt(b^2*se_a^2 + a^2*se_b^2)
# cat(sprintf("Sobel z=%.2f, p=%.3f\n", z, 2*pnorm(-abs(z))))

# --- 8. Logistic Regression: Notch Resolution (Table 6) ---
# model_notch <- glm(notch_resolved ~ uta_ri_pct + sal_fu + txb2_pct,
#                     data=data, family=binomial)
# exp(cbind(OR=coef(model_notch), confint(model_notch)))

# ============================================================================
# Figures were generated using Python (matplotlib/seaborn).
# See figures.py for figure generation code.
# ============================================================================
