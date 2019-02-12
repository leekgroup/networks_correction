library(sva)
library(huge)
library(QUIC)
library(parallel)
#simulate data

## generate simulated scale free network

if(!any(grepl("simulated_data.Rds", dir()))){
set.seed(101)
## generate simulated scale free network
dat <- huge.generator(n = 350, d = 5000, graph = "scale-free", v = NULL, u = NULL,
               g = NULL, prob = NULL, vis = F, verbose = TRUE)

sim.dat <- dat$data
sim.theta <- dat$theta
saveRDS(sim.dat, file = "simulated_data.Rds")
saveRDS(sim.theta, file = "simulated_network.Rds")
}else{
        sim.dat <- readRDS("simulated_data.Rds")
}

n <- nrow(sim.dat)
p <- ncol(sim.dat)

sim.dat.scaled <- scale(sim.dat)

sim.confounded=sim.dat.scaled
set.seed(101)
grp1=rnorm(n)
set.seed(102)
grp2=rnorm(n)
scalar_constant  = 2
set.seed(103)
prob1 = runif(1:1500, 0.1, 1)
prob2 = runif(1:1500, 0.1, 1)

probcount = 0

for(i in c(4001:4500, 1001:2000)){
	probcount = probcount + 1
	sim.confounded[,i] = sim.confounded[,i] + (scalar_constant * prob1[probcount]*grp1) + (scalar_constant * prob2[probcount]*grp2)
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
#saveRDS(sim.dat, file = "simulated_data.Rds")
#saveRDS(sim.theta, file = "simulated_network.Rds")
