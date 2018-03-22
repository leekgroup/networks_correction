## load configs and working directory
source("config")
source("functions.R")


## inputArguments
inputargs <- commandArgs(TRUE)
dat.type <- inputargs[1]
net.type <- inputargs[2]
networkType <- inputargs[4]
if(dat.type == "raw"){
	data.file <- raw.data
	save.dir <- raw
	## load data
        load(data.file)
	dat.net <- gtex.rse.sub
}

if(dat.type == "rin"){
	data.file <- rin.corrected
	save.dir <- rin
	## load data
        load(data.file)
        dat.net <- gtex.rse.rin
}

if(dat.type == "exon"){
	data.file <- exonic.dat
	save.dir <- exonic
	## load data
	load(data.file)
	dat.net <- gtex.rse.exon
}

if(dat.type == "multi3"){
        data.file <- multi3.dat
        save.dir <- multi3
        ## load data
        load(data.file)
        dat.net <- gtex.rse.multi3
}

if(dat.type == "multicorr"){
        data.file <- multicorr.dat
        save.dir <- multicorr
        ## load data
        load(data.file)
        dat.net <- gtex.rse.multicorr
}

if(dat.type == "gc"){
        data.file <- gc.dat
        save.dir <- gc
        ## load data
        load(data.file)
        dat.net <- gtex.rse.gc
}
if(dat.type == "pc"){
	data.file <- pc.corrected
	save.dir <- pc
	## load data
        load(data.file)
        dat.net <- gtex.pc.corrected
}

if(dat.type == "halfpc"){
	data.file <- half.pc.corrected
	save.dir <- half.pc
	## load data
        load(data.file)
        dat.net <- gtex.half.pc.corrected
}

if(dat.type == "quarter"){
	data.file <- quarter.pc.corrected
	save.dir <- quarter.pc
	## load data
        load(data.file)
        dat.net <- gtex.quarter.pc.corrected
}

if(dat.type == "thyroid_alternate"){
	data.file <- "/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/thyroid_alternate.Rdata"
	save.dir <- "/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/networks/thyroid_alternate/"
	dir.create(save.dir)
	load(data.file)
	dat.net <- thyroid.alternate.pc
}

if(dat.type == "thyroid_foxe"){
	data.file <- "/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/thyroid_foxe.Rdata"
	save.dir <- "/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/networks/thyroid_alternate/"
	dir.create(save.dir)
	load(data.file)
	dat.net <- thyroid.foxe.pc
}

if(net.type == "WGCNA"){
	## load data
	load(data.file)

	## set savename
	if(is.na(networkType)){
		networkType <- "unsigned"
		save.fn <- paste(save.dir, "wgcna_networks.RData", sep = "")
	}else{
		save.fn <- paste(save.dir, networkType, "_wgcna_networks.RData", sep = "")
	}
	print(save.fn)
	## run WGCNA
	wgcna.networks <- lapply(dat.net, function(x){
		x <- normalize(x)
		dat <- t(assay(x,1)) ## genes in columns for WGCNA
		# determine power
		power <- pick.power(dat, nType = networkType)
		print(power)
		## arguments for wgcna are defined in config file
	#	network.dat <- blockwiseModules(dat, power = power,TOMType = TOMType, minModuleSize = minModuleSize,
	#		reassignThreshold = reassignThreshold, mergeCutHeight = mergeCutHeight, numericLabels = numericLabels, 
	#		pamRespectsDendro = pamRespectsDendro,verbose = verbose, maxBlockSize = maxBlockSize)
		network.dat.first <- weighted.networks(dat, cutheights[1], power = power, networkType = networkType)
		network.dat <- weighted.networks(dat, cutheights[-1], power = power, blocks = network.dat.first$blocks, goodGenes = network.dat.first$goodGenes, goodSamples = network.dat.first$goodSamples, dendrograms = network.dat.first$dendrograms, networkType = networkType)
		network.dat <- c(list(network.dat.first), network.dat)
		network.dat
	})
	save(wgcna.networks, file = save.fn)

}

if(net.type == "glasso"){
	if(!dat.type %in% c("thyroid_foxe","thyroid_alternate")){
		## set savename
		tiss.name <- inputargs[3]
		save.dir <- paste(save.dir,"glasso/", sep = "")
		save.fn <- paste(save.dir, tiss.name, ".Rdata", sep = "")
		tiss.rse <- dat.net[[tiss.name]]
		print(tiss.name)
		}else{
			save.dir <- paste(save.dir,"glasso/", sep = "")
			save.fn <- paste(save.dir, dat.type, ".Rdata", sep = "")
			tiss.rse <- dat.net
			rm(dat.net)
		}
		## run QUIC to estimate precision matrix
			glasso.network <- graph.lasso(tiss.rse,
				rho.values = lambda,
				tolerance = tol,
				max.iter = maxIter)
			#glasso.network <- huge(gtex.pc.quantile.norm[[i]],
			#	lambda = lambda, method = "glasso")
			# save each network separately
		save(glasso.network, file = save.fn)
		print("Done")
		rm(glasso.network)
}
