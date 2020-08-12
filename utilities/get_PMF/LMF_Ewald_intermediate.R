# the periodic sum of the intermediate portion of solute-solute LMF potential
rm(list = ls())
library(tidyverse)
library(pracma)

vLMF_intermediate <- function(r){
  a <- 0.78
  b <- 0.75
  sig <- 0.5
  epsilon <- 71
  v <- a/epsilon*exp(-b*(r/sig)^2) 
  v
}

r <- seq(from = 0.01,to = 8, by = 0.1)
plot(r, vLMF_intermediate(r)) # less than 2 nm, periodic image not even necessary

proA_coord_charge <- readRDS("PO4_coord_charge")
proB_coord_charge <- readRDS("Ca_coord_charge")
boxx <- 3.16
boxy <- 3.16
boxz <- 3.95

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

saveRDS(df_LMF_intermediate, file = "df_PO4Ca_LMF_inter")
