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
sim.theta <- dat$theta
n <- nrow(sim.dat)
p <- ncol(sim.dat)
################### confounded
## confounded data

sim.dat.scaled <- scale(sim.dat)
sim.confounded=sim.dat.scaled
set.seed(101)
grp=rnorm(n)
scalar_constant  = 1
for(i in 1000:2000){
  sim.confounded[,i] = sim.confounded[,i] + scalar_constant*grp
}

set.seed(102)
grp=rnorm(n)

for(i in 1:500){
   sim.confounded[,i] = sim.confounded[,i] + scalar_constant*grp
}

### correct data
mod=matrix(1,nrow=dim(sim.confounded)[1],ncol=1)
colnames(mod)="Intercept"
nsv=num.sv(t(sim.confounded),mod, method = "be")
print(paste("the number of PCs estimated to be removed:", nsv))
ss=svd(scale(sim.confounded))
grp.est=ss$u[,1:nsv]
sim.corrected=lm(sim.confounded~grp.est)$residuals

saveRDS(sim.corrected, file = "simulated_corrected.Rds")
saveRDS(sim.confounded, file = "simulated_confounded.Rds")
saveRDS(sim.dat, file = "simulated_data.Rds")
saveRDS(sim.theta, file = "simulated_network.Rds")
