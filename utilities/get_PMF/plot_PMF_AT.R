rm(list = ls())
library(tidyverse)
library(here)
full <- readRDS(file = here("data/AT/umbrella/10blocks/df_AT_meanstd_10blocks" ))


GT <- readRDS(file = here("data/AT_GT/umbrella/10blocks/df_AT_GT_meanstd_10blocks"))


full$model <- "full"
GT$model <- "GT"



v_LMF_inter <- readRDS(here("utilities/get_PMF/df_TA_LMF_inter"))
v_LMF_inter_approx <- approx(x = v_LMF_inter$r, y = v_LMF_inter$v, xout = GT$r)

LMF <- data.frame(r = GT$r, pmf = GT$pmf + v_LMF_inter_approx$y, error = GT$error, model = "LMF")

df_full_GT_LMF <- do.call(rbind, list(full, GT, LMF))
p <- ggplot(data = df_full_GT_LMF,  mapping = aes(x = r, y = pmf, color = model))
p <- p + geom_line()
p <- p + geom_errorbar(aes(ymin = pmf - error, ymax = pmf + error))
p <- p + xlim(0.2, 0.9)
p
ggsave(here("utilities/get_PMF/AT_LMF_PMF.pdf"))
