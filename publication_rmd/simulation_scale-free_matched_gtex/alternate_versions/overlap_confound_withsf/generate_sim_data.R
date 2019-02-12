library(sva)
library(huge)
library(QUIC)
library(parallel)
#simulate data

set.seed(101)

if(!any(grepl("simulated_data.Rds", dir()))){

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
################### confounded
## confounded data

sim.dat.scaled <- scale(sim.dat)
sim.confounded=sim.dat.scaled

## set seed
set.seed(111)
seed_samples <- sample(100:200, 30)

for(eachseed in seed_samples){
	set.seed(eachseed)
	thisgrp = rnorm(n)
	sf = sample(2:3,1)
	sel.genes = sample(250:500, 1)
	thisgenes = sample(1500:3500, sel.genes)
	thisprob = runif(sel.genes, 0, 1)
	#print(thisgenes)
	print(sf)
	this_gene_prob = 0
	for(i in thisgenes){
		this_gene_prob = this_gene_prob + 1
  		sim.confounded[,i] = sim.confounded[,i] + (sf*thisgrp*thisprob[this_gene_prob])
	}
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
print("Done")
