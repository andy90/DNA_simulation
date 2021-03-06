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
  write(x = "Ang Gao Nucleotide", file = file_name, append = FALSE)
  linegro <- sprintf("%5d", nrow(df_out))
  write(x = linegro, file = file_name, append = TRUE)
  for (i in 1:nrow(df_out)){
    linegro <- sprintf("%5d%-5s%5s%5d%8.3f%8.3f%8.3f", 1, df_out[i,1], df_out[i,2], i, df_out[i,3], df_out[i,4], df_out[i,5])
    write(x = linegro, file = file_name, append = TRUE)
  }
  
  write("   2.00000   2.00000   2.00000", file = file_name, append = TRUE)
}

filepath <- here("utilities/make_config/")
C_init <- read.table(paste(filepath,"C_conf.txt" , sep = ""), stringsAsFactors = FALSE)
r_N3 <- as.numeric(C_init[C_init$V2 == 'N3', 4:6])
r_C6 <- as.numeric(C_init[C_init$V2 == 'C6', 4:6])
r_N3C6 <- r_N3 - r_C6
lengthvec(r_N3C6)

Ro <- get_rotation(r_N3C6, c(0,0,1))

C_xyz_inter <- as.matrix(C_init[, 4:6])
C_xyz_inter_2 <- sweep(C_xyz_inter, 2, r_C6)
C_xyz_inter_3 <- Ro %*% t(C_xyz_inter_2)  
rC5 <- C_xyz_inter_3[,C_init$V2 ==  'C5']
Ro2 <- get_rotation(c(rC5[1], rC5[2], 0), c(0,-1,0)) # rotate to the y z plane
C_xyz_final <- Ro2 %*% C_xyz_inter_3

df_C_final <- data.frame("res"="DC", "atom" = C_init$V2, t(C_xyz_final), stringsAsFactors = FALSE)


df_C_final$atom[1] <- "MCO"
df_C_final$res <- "XC"

saveRDS(df_C_final, file = paste(filepath,"df_C" , sep = ""))

write_to_gro(paste(filepath,"C.gro" , sep = ""), df_C_final)

