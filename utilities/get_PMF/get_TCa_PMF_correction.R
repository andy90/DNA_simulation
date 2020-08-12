rm(list = ls())
library(tidyverse)
library(pracma)
df_TCa <- readRDS("df_TCa")
a <- read_table(file = "TCacharges.txt", col_names = FALSE)
a$X1 == df_TCa$atom

df_TCa$q <- a$X3

df_T <-
  df_TCa %>%
  filter(res == "XT")

df_Ca <-
  df_TCa %>%
  filter(res == "CA")

vLMF <- function(r){
  a <- 0.78
  b <- 0.75
  sig <- 0.5
  epsilon <- 71
  v <- a/epsilon*exp(-b*(r/sig)^2) + 1/epsilon*erf(r/(5*sig))/r
  v
}

vLMF_intermediate <- function(r){
  a <- 0.78
  b <- 0.75
  sig <- 0.5
  epsilon <- 71
  v <- a/epsilon*exp(-b*(r/sig)^2) 
  v
}


plot(vLMF(seq(from = 0.01,to = 8, by = 0.1)),type = "l")

proA_coord_charge <- cbind(df_T[, 4:7])
colnames(proA_coord_charge) <- c("x", "y", "z", "q")

proB_coord_charge <- cbind(df_Ca[, 4:7])
colnames(proB_coord_charge) <- c("x", "y", "z", "q")

V1 <- 0
mV1 <- apply(proA_coord_charge, 1, function(row_A){
  apply(proB_coord_charge, 1, function(row_B){
    dis_ij <- sqrt( sum( (row_A[1:3] - row_B[1:3])^2 ) )
    q_i <- row_A[4]
    q_j <- row_B[4]
    q_i*q_j*vLMF(dis_ij)
  })
})
V1 <- sum(mV1)

getLMF <- function(x){
  proA_coord_charge <- cbind(df_T[, 4:7])
  colnames(proA_coord_charge) <- c("x", "y", "z", "q")
  
  proB_coord_charge <- cbind(df_Ca[, 4:7])
  colnames(proB_coord_charge) <- c("x", "y", "z", "q")
  
  proB_coord_charge$z <- proB_coord_charge$z + x
  
  V1 <- 0
  mV1 <- apply(proA_coord_charge, 1, function(row_A){
    apply(proB_coord_charge, 1, function(row_B){
      dis_ij <- sqrt( sum( (row_A[1:3] - row_B[1:3])^2 ) )
      q_i <- row_A[4]
      q_j <- row_B[4]
      q_i*q_j*vLMF(dis_ij)
    })
  })
  V1 <- sum(mV1)
  V1
}

getLMF_intermediate <- function(x){
  proA_coord_charge <- cbind(df_T[, 4:7])
  colnames(proA_coord_charge) <- c("x", "y", "z", "q")
  
  proB_coord_charge <- cbind(df_Ca[, 4:7])
  colnames(proB_coord_charge) <- c("x", "y", "z", "q")
  
  proB_coord_charge$z <- proB_coord_charge$z + x
  
  V1 <- 0
  mV1 <- apply(proA_coord_charge, 1, function(row_A){
    apply(proB_coord_charge, 1, function(row_B){
      dis_ij <- sqrt( sum( (row_A[1:3] - row_B[1:3])^2 ) )
      q_i <- row_A[4]
      q_j <- row_B[4]
      q_i*q_j*vLMF_intermediate(dis_ij)
    })
  })
  V1 <- sum(mV1)
  V1
}

getLMF_intermediate(1.0)

r <- seq(from = 0, to = 1, by = 0.1)
v <- sapply(r, function(ri){
  getLMF_intermediate(ri)
})
