rm(list = ls())
library(tidyverse)
library(pracma)
library(here)

lengthvec <- function(x){
  sqrt(sum(x^2))
}

get_rotation <- function(x, y){
  
  nx <- x/lengthvec(x)
  y <- y/lengthvec(y)
  new_ax <- cross(nx, y)/lengthvec(cross(nx, y))
  
  phi <- as.numeric(acos(nx %*% y))
  
  W <- matrix(c(0,new_ax[3],-new_ax[2],-new_ax[3],0,new_ax[1],new_ax[2],-new_ax[1],0), nrow = 3)
  
  
  Ro <- diag(3) + sin(phi) * W + 2*sin(phi/2)^2*W %*% W
  
}

write_to_gro <- function(file_name, df_out){
  write(x = "Ang Gao NO3-", file = file_name, append = FALSE)
  linegro <- sprintf("%5d", nrow(df_out))
  write(x = linegro, file = file_name, append = TRUE)
  for (i in 1:nrow(df_out)){
    linegro <- sprintf("%5d%-5s%5s%5d%8.3f%8.3f%8.3f", 1, df_out[i,1], df_out[i,2], i, df_out[i,3], df_out[i,4], df_out[i,5])
    write(x = linegro, file = file_name, append = TRUE)
  }
  
  write("   2.00000   2.00000   2.00000", file = file_name, append = TRUE)
}

filepath <- here("utilities/make_config/")
NO3_init <- read.table(paste(filepath, "NO3-.txt", sep = ""), stringsAsFactors = FALSE)
r_N <- as.numeric(NO3_init[NO3_init$V2 == 'N', 4:6])
r_O1 <- as.numeric(NO3_init[NO3_init$V2 == 'O1', 4:6])

r_O1N <- r_O1 - r_N
lengthvec(r_O1N)

Ro <- get_rotation(r_O1N, c(0,0,1))

NO3_xyz_inter <- as.matrix(NO3_init[, 4:6])
NO3_xyz_inter_2 <- sweep(NO3_xyz_inter, 2, r_N)
NO3_xyz_inter_3 <- Ro %*% t(NO3_xyz_inter_2)

rO2 <- NO3_xyz_inter_3[,NO3_init$V2 ==  'O2']
Ro2 <- get_rotation(c(rO2[1], rO2[2], 0), c(0,-1,0)) # rotate to the y z plane
NO3_xyz_final <- Ro2 %*% NO3_xyz_inter_3
