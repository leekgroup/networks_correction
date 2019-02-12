library(sva)
library(huge)
library(QUIC)
library(parallel)
library(Matrix)

######## functions
q_normalize <- function(dat){
  n = nrow(dat)
  p = ncol(dat)
  rank.dat =  dat # matrix for ranking
  for (i in 1:p){
    rank.dat[,i] = rank(dat[,i])
  }
  U = rank.dat/(n+1)
  norm.dat = qnorm(U)
  norm.dat
}
###################


lambda=seq(0.1,1,length.out=20)

## read input
inputargs <- commandArgs(TRUE)
fn <- inputargs[1]
#sn <- inputargs[2]
## load data
sim.dat <- readRDS(paste("simulated_", fn, ".Rds", sep = ""))

## build networks
sim.cov <- cov(scale(sim.dat))

sim.net <- mclapply(lambda, function(graphlasso, thisdat){
  thisnet <- QUIC::QUIC(S = thisdat, rho = graphlasso)$X
  thisnet[thisnet!=0] <- 1
  thisnet <- Matrix(thisnet, sparse = T)
  thisnet
}, sim.cov, mc.cores = 29)


saveRDS(sim.net, file = paste("networks_", fn, ".Rds", sep = ""))

