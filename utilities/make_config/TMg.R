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
df_C <- readRDS(paste(filepath, "df_T", sep = ""))
rC_N3 <- as.numeric(df_C[df_C$atom == "H3", 3:5])
Cxyz <- df_C[, 3:5]
Cxyz_new <- sweep(Cxyz, 2, rC_N3 - c(1.5, 1.5, 1.5))
df_C_new <- data.frame(id = 1, df_C[, 1:2], Cxyz_new)
df_Mg <- data.frame(id =2, res = "MG", atom = "MG", X1 = 1.5, X2 = 1.5, X3 = 1.75)

df_CMg <- rbind(df_C_new, df_Mg)

saveRDS(df_CMg, file = paste(filepath, "df_TMg", sep = ""))
write_to_gro(paste(filepath, "TMg.gro", sep = ""), df_CMg)

