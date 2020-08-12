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
df_PO4 <- readRDS(paste(filepath, "df_PO4", sep = ""))

rA_N1 <- as.numeric(df_A[df_A$atom == "N1", 3:5])

Axyz <- df_A[, 3:5]

Axyz_new <- sweep(Axyz, 2, rA_N1 - c(1.5, 1.5, 1.8)) 

df_A_new <- data.frame(id = 2, df_A[, 1:2], Axyz_new)

df_APO4 <- rbind(df_PO4, df_A_new)

write_to_gro(paste(filepath, "APO4.gro", sep = ""), df_APO4)
saveRDS(df_APO4, file = paste(filepath, "df_APO4", sep = ""))
