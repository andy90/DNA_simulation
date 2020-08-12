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
########
# rotate for the A
########
filepath <- here("utilities/make_config/")
A_init <- read.table(paste(filepath, "A_conf.txt", sep = ""), stringsAsFactors = FALSE)
r_C4 <- as.numeric(A_init[A_init$V2 == 'C4', 4:6])
r_N1 <- as.numeric(A_init[A_init$V2 == 'N1', 4:6])
r_C4N1 <- r_C4 - r_N1
lengthvec(r_C4N1)

Ro <- get_rotation(r_C4N1, c(0,0,1))

A_xyz_inter <- as.matrix(A_init[, 4:6])
A_xyz_inter_2 <- sweep(A_xyz_inter, 2, r_N1)
A_xyz_inter_3 <- Ro %*% t(A_xyz_inter_2)  
rC6 <- A_xyz_inter_3[,A_init$V2 ==  'C6']
Ro2 <- get_rotation(c(rC6[1], rC6[2], 0), c(0,-1,0)) # rotate to the y z plane
A_xyz_final <- Ro2 %*% A_xyz_inter_3

df_A_final <- data.frame("res"="DA", "atom" = A_init$V2, t(A_xyz_final), stringsAsFactors = FALSE)

df_A_final$atom[1] <- "MCO"
df_A_final$res <- "XA"

saveRDS(df_A_final, file = paste(filepath, "df_A", sep = "") )
write_to_gro(paste(filepath,"A.gro" , sep = ""), df_A_final)
