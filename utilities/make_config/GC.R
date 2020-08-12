rm(list = ls())
library(tidyverse)
library(here)
write_to_gro <- function(file_name, df_out){
  write(x = "Ang Gao Nucleotide", file = file_name, append = FALSE)
  linegro <- sprintf("%5d", nrow(df_out))
  write(x = linegro, file = file_name, append = TRUE)
  for (i in 1:nrow(df_out)){
    linegro <- sprintf("%5d%-5s%5s%5d%8.3f%8.3f%8.3f", df_out[i,1], df_out[i,2], df_out[i,3], i, df_out[i,4], df_out[i,5], df_out[i,6])
    write(x = linegro, file = file_name, append = TRUE)
  }
  
  write("   3.20000   3.20000   3.20000", file = file_name, append = TRUE)
}

filepath <- here("utilities/make_config/")

df_G <- readRDS(paste(filepath, "df_G", sep = ""))
df_C <- readRDS(paste(filepath, "df_C", sep = ""))

rG_N1 <- as.numeric(df_G[df_G$atom == "N1", 3:5])
rC_N3 <- as.numeric(df_C[df_C$atom == "N3", 3:5])

Gxyz <- df_G[, 3:5]
Cxyz <- df_C[, 3:5]

Gxyz_new <- sweep(Gxyz, 2, rG_N1 - c(1.5, 1.5, 1.78)) 
Cxyz_new <- sweep(Cxyz, 2, rC_N3 - c(1.5, 1.5, 1.5))

df_G_new <- data.frame(id = 2, df_G[, 1:2], Gxyz_new)
df_C_new <- data.frame(id = 1, df_C[, 1:2], Cxyz_new)

df_GC <- rbind(df_C_new, df_G_new)

saveRDS(df_GC, file = paste(filepath, "df_GC", sep = ""))
write_to_gro(paste(filepath, "GC.gro", sep = ""), df_GC)

