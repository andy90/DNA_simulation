rm(list = ls())
library(tidyverse)

full <- read.table(file = "ang_base_pair_top/PO4Ca/umbrella/profile.xvg" )
full_av <- 
  full %>%
  filter((V1 > 1.35) & (V1 < 1.45)) %>%
  summarise(bulk = mean(V2)) %>%
  pull()

full$V2 <- full$V2 - full_av

GT <- read.table(file = "ang_base_pair_top/PO4Ca_GT/umbrella/profile.xvg" )
GT_av <- 
  GT %>%
  filter((V1 > 1.35) & (V1 < 1.45)) %>%
  summarise(bulk = mean(V2)) %>%
  pull()

GT$V2 <- GT$V2 - GT_av

full$model <- "full"
GT$model <- "GT"

df_full_GT <- rbind(full, GT)
df_full_GT <- 
  df_full_GT %>% 
  set_names(c("r", "w", "model"))


p <- ggplot(data = df_full_GT)
p <- p + geom_line(mapping = aes(x = r, y = w, color = model))
p <- p + xlim(0.2, 1.5)
p
ggsave("PO4Ca_PMF.pdf")

v_LMF_inter <- readRDS("df_PO4Ca_LMF_inter")
v_LMF_inter_approx <- approx(x = v_LMF_inter$r, y = v_LMF_inter$v, xout = GT$V1)

LMF <- data.frame(r = GT$V1, w = GT$V2 + v_LMF_inter_approx$y, model = "LMF")

df_full_GT_LMF <- rbind(df_full_GT, LMF)
p <- ggplot(data = df_full_GT_LMF)
p <- p + geom_line(mapping = aes(x = r, y = w, color = model))
p <- p + xlim(0.2, 1.5)
p
ggsave("PO4Ca_LMF_PMF.pdf")
