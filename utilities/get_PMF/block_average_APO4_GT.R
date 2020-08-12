rm(list = ls())
library(tidyverse)
library(foreach)
library(matrixStats)
folder_path <- "ang_base_pair_top/APO4_GT/umbrella/10blocks/"
file_name <- "APO4_GT"
n_block <- 10

all_pmfs <- 
  foreach( i = 0:(n_block-1), .combine = "c") %do% {
    pmf_file <- paste(folder_path, "pmf", i, ".xvg", sep = "")
    all_content <-readLines(pmf_file)
    a_reduced <- all_content[!grepl("#|@", all_content)]
    pmf <- read.csv(textConnection(a_reduced), stringsAsFactors = FALSE, header = FALSE, sep="")
    
    pmf_av <- 
      pmf %>%
      filter((V1 > 0.9) & (V1 < 1.0)) %>%
      summarise(bulk = mean(V2)) %>%
      pull()
    
    pmf$V2 <- pmf$V2 - pmf_av
    
    list(pmf)
  }

x1 <- all_pmfs[[1]]$V1
dx <- mean(x1[2:length(x1)] - x1[1:(length(x1)-1)])

ndata <- nrow(all_pmfs[[1]])
xleft <- max(unlist(lapply(all_pmfs, function(pmf){
  pmf$V1[1]
})))
xright <- min(unlist(lapply(all_pmfs, function(pmf){
  pmf$V1[ndata]
}))) 

r <- seq(xleft, xright, length.out = ndata)

all_pmfs_interp <-
  foreach( i = 1:n_block, .combine = "cbind") %do% {
    approx(x = all_pmfs[[i]]$V1, y = all_pmfs[[i]]$V2, xout = r)$y
  }
pmf_mean <- rowMeans(all_pmfs_interp)
pmf_std <- rowSds(all_pmfs_interp)/sqrt(n_block)

df_pmf_final <- data.frame(r = r, pmf = pmf_mean, error = pmf_std)

saveRDS(df_pmf_final, file = paste(folder_path, "df_", file_name, "_meanstd_", n_block, "blocks", sep = ""))
write.table(x = df_pmf_final, file = paste(folder_path, "df_", file_name, "_meanstd_", n_block, "blocks.txt", sep = ""), row.names = FALSE, col.names = FALSE, quote = FALSE)
p <- ggplot(data = df_pmf_final, mapping = aes(x = r, y = pmf))
p <- p + geom_line()
p <- p + geom_errorbar(aes(ymin = pmf - error, ymax = pmf + error))
p <- p + xlim(0.35, 1.0)
p
