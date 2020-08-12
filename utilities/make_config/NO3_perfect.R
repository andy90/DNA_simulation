rm(list = ls())
library(tidyverse)
library(here)
write_to_gro <- function(file_name, df_out){
  write(x = "Ang Gao NO3", file = file_name, append = FALSE)
  linegro <- sprintf("%5d", nrow(df_out))
  write(x = linegro, file = file_name, append = TRUE)
  for (i in 1:nrow(df_out)){
    linegro <- sprintf("%5d%-5s%5s%5d%8.3f%8.3f%8.3f", 1, df_out[i,1], df_out[i,2], i, df_out[i,3], df_out[i,4], df_out[i,5])
    write(x = linegro, file = file_name, append = TRUE)
  }
  
  write("   2.00000   2.00000   2.00000", file = file_name, append = TRUE)
}

filepath <- here("utilities/make_config/")

rN <- c(0, 0, 0)
rO1 <- c(0, 0, 1.26)
rO2 <- c(0, cos(30/180*pi)*1.26, -sin(30/180*pi)*1.26)
rO3 <- c(0, -cos(30/180*pi)*1.26, -sin(30/180*pi)*1.26)

NO3_xyz <- do.call("rbind", list(rN, rO1, rO2, rO3))
df_NO3_final <- data.frame("res"="NO3", "atom" = c("NG", "OG1", "OG2", "OG3"), NO3_xyz, stringsAsFactors = FALSE)

write_to_gro(paste(filepath, "NO3.gro", sep = ""), df_NO3_final)

