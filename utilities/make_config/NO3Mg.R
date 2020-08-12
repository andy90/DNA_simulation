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

rN <- c(0, 0, 0)
rO1 <- c(0, 0, 0.126)
rO2 <- c(0, cos(30/180*pi)*0.126, -sin(30/180*pi)*0.126)
rO3 <- c(0, -cos(30/180*pi)*0.126, -sin(30/180*pi)*0.126)

NO3_xyz <- do.call("rbind", list(rN, rO1, rO2, rO3))
NO3_new <- sweep(NO3_xyz, 2, rN - c(1.5, 1.5, 1.5))

df_NO3_final <- data.frame(id = 1, "res"="NO3", "atom" = c("NG", "OG1", "OG2", "OG3"), NO3_new, stringsAsFactors = FALSE)

df_Mg <- data.frame(id =2, res = "MG", atom = "MG", X1 = 1.5, X2 = 1.5, X3 = 1.9)

df_NO3Mg <- rbind(df_NO3_final, df_Mg)
saveRDS(df_NO3Mg, file = paste(filepath, "df_NO3Mg", sep = ""))
write_to_gro(paste(filepath, "NO3Mg.gro", sep = ""), df_NO3Mg)
