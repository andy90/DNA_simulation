rm(list = ls())
library(tidyverse)

full <- read.table(file = "ang_base_pair_top/APO4/umbrella/profile_no0.xvg" )
full_av <- 
  full %>%
  filter((V1 > 0.9) & (V1 < 1.0)) %>%
  summarise(bulk = mean(V2)) %>%
  pull()

full$V2 <- full$V2 - full_av

GT <- read.table(file = "ang_base_pair_top/APO4_GT/umbrella/profile_no0.xvg" )
GT_av <- 
  GT %>%
  filter((V1 > 0.9) & (V1 < 1.0)) %>%
  summarise(bulk = mean(V2)) %>%
  pull()

GT$V2 <- GT$V2 - GT_av

full$model <- "full"
GT$model <- "GT"

df_full_GT <- rbind(full, GT)
df_full_GT <- 
  df_full_GT %>% 
  set_names(c("r", "w", "model"))




df_APO4_errorbar <- readRDS("df_APO4_full_meanstd")
df_APO4_new <- 
  df_APO4_errorbar %>%
  select(r, pmf) %>%
  set_names("r", "w") %>%
  mutate(model= "av")

df_full_GT <- rbind(df_full_GT, df_APO4_new) %>% filter(model != "GT")
p <- ggplot(data = df_full_GT)
p <- p + geom_line(mapping = aes(x = r, y = w, color = model))
p <- p + xlim(0.39, 1.25)
p # almost exactly matches

#ggsave("PO4Ca_PMF.pdf")

# v_LMF_inter <- readRDS("df_PO4Ca_LMF_inter")
# v_LMF_inter_approx <- approx(x = v_LMF_inter$r, y = v_LMF_inter$v, xout = GT$V1)
# 
# LMF <- data.frame(r = GT$V1, w = GT$V2 + v_LMF_inter_approx$y, model = "LMF")
# 
# df_full_GT_LMF <- rbind(df_full_GT, LMF)
# p <- ggplot(data = df_full_GT_LMF)
# p <- p + geom_line(mapping = aes(x = r, y = w, color = model))
# p <- p + xlim(0.2, 1.5)
# p
# ggsave("PO4Ca_LMF_PMF.pdf")
