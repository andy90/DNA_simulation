rm(list = ls())
library(tidyverse)
library(here)
write_to_gro <- function(file_name, df_out){
  write(x = "Ang Gao PO4 Ca", file = file_name, append = FALSE)
  linegro <- sprintf("%5d", nrow(df_out))
  write(x = linegro, file = file_name, append = TRUE)
  for (i in 1:nrow(df_out)){
    linegro <- sprintf("%5d%-5s%5s%5d%8.3f%8.3f%8.3f", df_out[i,1], df_out[i,2], df_out[i,3], i, df_out[i,4], df_out[i,5], df_out[i,6])
    write(x = linegro, file = file_name, append = TRUE)
  }
  
  write("   3.20000   3.20000   4.00000", file = file_name, append = TRUE)
}

filepath <- here("utilities/make_config/")
dPO <- 0.14800 # P O2 dist in amber
theta <- 109.4712206
theta1 <- (theta - 90)/180*pi
theta2 <- 30/180*pi
rP <- c(0, 0, 0)
rO1 <- c(-dPO*cos(theta1)*cos(theta2), -dPO*cos(theta1)*sin(theta2), -dPO*sin(theta1))
rO2 <- c(dPO*cos(theta1)*cos(theta2), -dPO*cos(theta1)*sin(theta2), -dPO*sin(theta1))
rO3 <- c(0, dPO*cos(theta1), -dPO*sin(theta1))
rO4 <- c(0, 0, dPO)

PO4_xyz <- do.call("rbind", list(rP, rO1, rO2, rO3, rO4))
PO4_new <- sweep(PO4_xyz, 2, rP - c(1.5, 1.5, 1.5-dPO))

df_PO4_final <- data.frame(id = 1, "res"="PO4", "atom" = c("PG", "OG1", "OG2", "OG3", "OG4"), PO4_new, stringsAsFactors = FALSE)

df_CA <- data.frame(id =2, res = "CA", atom = "CA", X1 = 1.5, X2 = 1.5, X3 = 1.8)

df_PO4CA <- rbind(df_PO4_final, df_CA)
saveRDS(df_PO4CA, file = paste(filepath, "df_PO4Ca", sep = ""))
write_to_gro(paste(filepath, "PO4Ca.gro", sep = ""), df_PO4CA)

