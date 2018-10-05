## load configs and working directory
source("config.R")
source("functions.R")


## inputArguments
inputargs <- commandArgs(TRUE)
dat.fn <- inputargs[1]
TOMType <- inputargs[2]
save.fn <- inputargs[3]
print(inputargs)
load(dat.fn)

dat.expr <- lapply(dat.expr, function(x){
		x <- q_normalize(x)
		x
	})

dat.net <- vector("list", length = length(dat.expr))
names(dat.net) <- names(dat.expr)
if(TOMType == "signed"){
	power <- c(1:30)
}
if(TOMType =="unsigned"){
	power <- c(1:15)
}

num.cores <- detectCores()

for(i in 1:length(dat.expr)){
	print(paste("Now running", names(dat.expr)[i],"\n"))
	dat <- t(assay(dat.expr[[i]], 1))
	temp_th <- pickSoftThreshold(dat, networkType = TOMType)

	dat.net[[i]] <- mclapply(power, function(x,type.tom, min.mod.size, tissData){
			network_this_pow <- blockwiseModules(tissData, power = x, TOMType = type.tom,
				pamRespectsDendro = FALSE, mergeCutHeight = 0.25,
                                minModuleSize = 20, networkType = type.tom,
                                numericLabels = TRUE,
                                verbose = 3)
			network_this_pow
        }, TOMType, minModuleSize, dat, mc.preschedule = FALSE, mc.cores = num.cores)
}

save(dat.net, file = save.fn)
