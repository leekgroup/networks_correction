## load configs and working directory
source("config.R")
source("functions.R")
library("Hmisc")

## inputArguments
inputargs <- commandArgs(TRUE)
dat.fn <- inputargs[1]
TOMType <- inputargs[2]
save.fn <- inputargs[3]

load(dat.fn)

dat.expr <- lapply(dat.expr, function(x){
		x <- q_normalize(x)
		x
	})

print(names(dat.expr))
dat.net <- lapply(dat.expr, function(x, type.tom){
	dat <- t(assay(x, 1)) ## genes in columns for WGCNA
	# determine power
	power <- pick.power(dat, nType = type.tom)
	print(power)
	dat.corr.power <- (abs(cor(dat)))
	},TOMType)

save(dat.net, file = save.fn)
