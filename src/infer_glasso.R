## load configs and working directory
source("config.R")
source("functions.R")
library("Hmisc")

## inputArguments
inputargs <- commandArgs(TRUE)
dat.fn <- inputargs[1]
tiss.name <- inputargs[2]
save.fn <- inputargs[3]
print(inputargs)
load(dat.fn)

# q_normalize the data to have a gaussian distribution
dat.expr <- q_normalize(dat.expr[[tiss.name]])

# compute covariance matrix
dat.expr <- t(assay(dat.expr, 1)) ## genes in the column 
cov.mat <- cov(dat.expr)

# learn co-expression network with graphical lasso
dat.net <- mclapply(lambda, function(eachRho, dat, toler, iters){
		print(eachRho)
		p.mat <- QUIC(dat, rho = eachRho, tol = toler, maxIter = iters)$X
		p.mat[lower.tri(p.mat)] <- NA
    	p.mat[p.mat == 0.0] <- NA
    	diag(p.mat) <- NA
    	colnames(p.mat) <- colnames(dat)
	rownames(p.mat) <- rownames(dat)
	p.mat
		}, cov.mat, tol, maxIter, mc.preschedule = F, mc.cores = 5)

save(dat.net, file = save.fn)
