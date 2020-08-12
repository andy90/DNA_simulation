# the periodic sum of the long range portion of solute-solute LMF

rm(list = ls())
library(tidyverse)
library(pracma)

vLMF_long <- function(r){
  sig <- 0.5
  epsilon <- 71
  v <-  1/epsilon*erf(r/(5*sig))/r
  v
}

vLMF_long_fourier <- function(k){

  sig <- 0.5
  epsilon <- 71
  
  vk <- 4*pi/(k^2)/epsilon*exp(-k^2*(5*sig)^2/4)
}

r <- seq(from = 0.01,to = 8, by = 0.1)
plot(r, vLMF_long(r)) # less than 2 nm, periodic image not even necessary

proA_coord_charge <- readRDS("PO4_coord_charge")
proB_coord_charge <- readRDS("Ca_coord_charge")
boxx <- 3.16
boxy <- 3.16
boxz <- 3.95

kx <- 2*pi/boxx
ky <- 2*pi/boxy
kz <- 2*pi/boxz

get_LMF_long <- function(x){
  proB_coord_charge$z <- proB_coord_charge$z + x
  
  v_temp <- 0
  for (i in -1:1){ # i,j,k is the number of k vectors
    for ( j in -1:1){
      for (k in -1:1){
        
        if (!((i == 0) & (j == 0) & (k ==0))){
          rhok_real <- 0
          rhok_complex <- 0
          
          for (iA in 1:nrow(proA_coord_charge)){
            q_iA <- proA_coord_charge$q
            x_iA <- proA_coord_charge$x
            y_iA <- proA_coord_charge$y
            z_iA <- proA_coord_charge$z
            
            rhok_real <- rhok_real + q_iA * cos(i*kx*x_iA + j*ky*y_iA + k*kz*z_iA)
            rhok_complex <- rhok_complex + q_iA * sin(i*kx*x_iA + j*ky*y_iA + k*kz*z_iA)
          }
          
          for (iB in 1:nrow(proB_coord_charge)){
            q_iB <- proB_coord_charge$q
            x_iB <- proB_coord_charge$x
            y_iB <- proB_coord_charge$y
            z_iB <- proB_coord_charge$z
            
            rhok_real <- rhok_real + q_iB * cos(i*kx*x_iB + j*ky*y_iB + k*kz*z_iB)
            rhok_complex <- rhok_complex + q_iB * sin(i*kx*x_iB + j*ky*y_iB + k*kz*z_iB)
          }
          
          rhok_modulus <- rhok_real^2 + rhok_complex^2
          kk <- sqrt(kx^2 + ky^2 + kz^2)
          v_temp <- v_temp + rhok_modulus * vLMF_long_fourier(kk)
        }
      }
    }
  }
  
  v_temp <- v_temp/(2 * boxx * boxy * boxz) # p318 of Frenkel and Smit
}

print(get_LMF_long(0))
