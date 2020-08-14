# the periodic sum of the intermediate portion of solute-solute LMF potential
rm(list = ls())
library(tidyverse)
library(pracma)
library(here)
vLMF_intermediate <- function(r){
  a <- 0.78
  b <- 0.75
  sig <- 0.5
  epsilon <- 71
  v <- a/epsilon*exp(-b*(r/sig)^2) 
  v
}

filepath <- here("utilities/get_PMF/")
filepath2 <- here("utilities/make_config/")
df_AB <- readRDS(paste(filepath2, "df_APO4", sep = ""))
a <- read_table(file = paste(filepath, "APO4charges.txt", sep = ""), col_names = FALSE)

a$X1 == df_AB$atom

df_AB$q <- a$X3

df_A <-
  df_AB %>%
  filter(res == "PO4")

df_B <-
  df_AB %>%
  filter(res == "XA")

proA_coord_charge <- cbind(df_A[, 4:7])
colnames(proA_coord_charge) <- c("x", "y", "z", "q")

proB_coord_charge <- cbind(df_B[, 4:7])
colnames(proB_coord_charge) <- c("x", "y", "z", "q")

boxx <- 3.15
boxy <- 3.15
boxz <- 3.15

get_LMF_intermediate <- function(x){
  
  proB_coord_charge$z <- proB_coord_charge$z + x
  
  mV1 <- apply(proA_coord_charge, 1, function(row_A){
    apply(proB_coord_charge, 1, function(row_B){
      v_temp <- 0
      for (i in -1:1){
        for ( j in -1:1){
          for (k in -1:1){
            dis_ij <- sqrt( sum( (row_A[1:3] - row_B[1:3] + c(i*boxx,  j*boxy, k*boxz))^2 ) )
            q_i <- row_A[4]
            q_j <- row_B[4]
            v_temp <- v_temp + q_i*q_j*vLMF_intermediate(dis_ij)
          }
        }
      }
      v_temp
    })
  })
  V1 <- sum(mV1)
}

r <- seq(from = -0.1, to = 1.6, by = 0.01)
v <- sapply(r, function(ri){
  get_LMF_intermediate(ri)
})

v*138/2.5

plot(r + 0.3, v*138/2.5)

df_LMF_intermediate <- data.frame("r" = r+0.3, "v" = v*138/2.5)

saveRDS(df_LMF_intermediate, file = paste(filepath, "df_APO4_LMF_inter", sep = ""))
