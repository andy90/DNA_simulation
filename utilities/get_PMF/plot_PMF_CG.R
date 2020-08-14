rm(list = ls())
library(tidyverse)
library(here)
full <- readRDS(file = here("data/CG/umbrella/10blocks/df_CG_meanstd_10blocks" ))


GT <- readRDS(file = here("data/CG_GT/umbrella/10blocks/df_CG_GT_meanstd_10blocks"))


full$model <- "full"
GT$model <- "GT"



v_LMF_inter <- readRDS(here("utilities/get_PMF/df_CG_LMF_inter"))
v_LMF_inter_approx <- approx(x = v_LMF_inter$r, y = v_LMF_inter$v, xout = GT$r)

LMF <- data.frame(r = GT$r, pmf = GT$pmf + v_LMF_inter_approx$y, error = GT$error, model = "LMF")

df_full_GT_LMF <- do.call(rbind, list(full, GT, LMF))
p <- ggplot(data = df_full_GT_LMF,  mapping = aes(x = r, y = pmf, color = model))
p <- p + geom_line()
p <- p + geom_errorbar(aes(ymin = pmf - error, ymax = pmf + error))
p <- p + xlim(0.2, 0.9)
p
ggsave(here("utilities/get_PMF/CG_LMF_PMF.pdf"))
