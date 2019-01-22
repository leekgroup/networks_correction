library(sva)
library(huge)
library(QUIC)
library(parallel)
#simulate data

lambda=seq(0,1,length.out=30)[-1]
set.seed(101)
## generate simulated scale free network
dat <- huge.generator(n = 350, d = 5000, graph = "scale-free", v = NULL, u = NULL,
               g = NULL, prob = NULL, vis = F, verbose = TRUE)
sim.dat <- dat$data
n <- nrow(sim.dat)
p <- ncol(sim.dat)


## build networks
sim.cov <- cov(scale(sim.dat))
sim.net <- mclapply(lambda, function(graphlasso, thisdat){
  thisnet <- QUIC::QUIC(S = thisdat, rho = graphlasso)$X
  thisnet[thisnet!=0] <- 1
  thisnet
}, sim.cov, mc.cores = 29)

a <- 1

save(sim.net, file = "sim.Rdata")

################### confounded
## confounded data

sim.confounded=sim.dat
set.seed(101)
grp=rnorm(n)
for(i in 10:30){
  sim.confounded[,i] = sim.confounded[,i] + 5*grp
}

sim.confounded.cov <- cov(scale(sim.confounded))

sim.confounded.net <- mclapply(lambda, function(graphlasso, thisdat){
  thisnet <- QUIC::QUIC(S = thisdat, rho = graphlasso)$X
  thisnet[thisnet!=0] <- 1
  thisnet
}, sim.confounded.cov, mc.cores = 29)
save(sim.confounded.net, file = "sim_confounded.Rdata")

################### corrected
mod=matrix(1,nrow=dim(sim.confounded)[1],ncol=1)
colnames(mod)="Intercept"
nsv=num.sv(t(sim.confounded),mod, method = "be")
print(paste("the number of PCs estimated to be removed:", nsv))
ss=svd(scale(sim.confounded))
grp.est=ss$u[,1:nsv]
sim.corrected=lm(sim.confounded~grp.est)$residuals

sim.corrected.cov <- cov(scale(sim.corrected))

sim.corrected.net <- mclapply(lambda, function(graphlasso, thisdat){
  thisnet <- QUIC::QUIC(S = thisdat, rho = graphlasso)$X
  thisnet[thisnet!=0] <- 1
  thisnet
}, sim.corrected.cov, mc.cores = 29)

save(sim.corrected.net, file = "sim_corrected.Rdata")

##############################################
