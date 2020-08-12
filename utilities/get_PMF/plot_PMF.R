rm(list = ls())
library(tidyverse)

full <- read.table(file = "ang_base_pair_top/data_pullCG/umbrella/profile.xvg" )
full_av <- 
  full %>%
  filter((V1 > 0.95) & (V1 < 1.05)) %>%
  summarise(bulk = mean(V2)) %>%
  pull()

full$V2 <- full$V2 - full_av

GT <- read.table(file = "ang_base_pair_top/data_CG_GT/umbrella/profile.xvg" )
GT_av <- 
  GT %>%
  filter((V1 > 0.95) & (V1 < 1.05)) %>%
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
p <- p + xlim(0.25, 1.2)
p
ggsave("GC_PMF.pdf")
