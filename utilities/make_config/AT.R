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

df_A <- readRDS(paste(filepath, "df_A", sep = ""))
df_T <- readRDS(paste(filepath, "df_T", sep = ""))

rA_N1 <- as.numeric(df_A[df_A$atom == "N1", 3:5])
rT_N3 <- as.numeric(df_T[df_T$atom == "N3", 3:5])

Axyz <- df_A[, 3:5]
Txyz <- df_T[, 3:5]

Axyz_new <- sweep(Axyz, 2, rA_N1 - c(1.5, 1.5, 1.78)) 
Txyz_new <- sweep(Txyz, 2, rT_N3 - c(1.5, 1.5, 1.5))

df_A_new <- data.frame(id = 2, df_A[, 1:2], Axyz_new)
df_T_new <- data.frame(id = 1, df_T[, 1:2], Txyz_new)

df_AT <- rbind(df_T_new, df_A_new)

saveRDS(df_AT, file = paste(filepath, "df_AT", sep = ""))
write_to_gro(paste(filepath, "AT.gro", sep = ""), df_AT)

