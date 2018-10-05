## load configs and working directory
source("config.R")
source("functions.R")


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

dat.net <- lapply(dat.expr, function(x, type.tom, min.mod.size, re.threshold, cut.height, merge.height){
	dat <- t(assay(x, 1)) ## genes in columns for WGCNA
	# determine power
	power <- pick.power(dat, nType = type.tom)
	print(power)

	## Infer network at one cut height, save TOM and then just re-cut and reinfer module from TOM --> faster
	network.dat.first <- blockwiseModules(dat, power = power,TOMType = type.tom, saveTOMs = TRUE,
                                minModuleSize = min.mod.size, networkType = type.tom,
                                reassignThreshold = re.threshold, 
                                detectCutHeight = cut.height[1], 
                                mergeCutHeight = merge.height,
                                numericLabels = TRUE, 
                                pamRespectsDendro = FALSE,
                                verbose = 3)

	## recut using TOM saved from first network
	network.dat <- lapply(cut.height[-1], function(cut.a, expr.dat, blocks.net, mod.size, good.genes.net, good.samples.net, dendrogram.net, net.type.tom, re.thresh, m.height){
					print(cut.a)
					recutBlockwiseTrees(expr.dat, blocks = blocks.net, TOMFiles = "blockwiseTOM-block.1.RData", 
						minModuleSize = mod.size, goodGenes = good.genes.net, 
						goodSamples = good.samples.net, networkType = net.type.tom, 
						reassignThreshold = re.thresh, detectCutHeight = cut.a, 
						mergeCutHeight = m.height, dendrograms = dendrogram.net,
                        numericLabels = TRUE, pamRespectsDendro = FALSE,
                        verbose = 3)
			}, dat, network.dat.first$blocks, min.mod.size, network.dat.first$goodGenes, network.dat.first$goodSamples, 
			network.dat.first$dendrograms, type.tom, re.threshold, merge.height)
	network.dat <- c(list(network.dat.first), network.dat)
	names(network.dat) <- cut.height
	file.remove("blockwiseTOM-block.1.RData")
	network.dat
	}, TOMType, minModuleSize, reassignThreshold, cutheights, mergeCutHeight)

save(dat.net, file = save.fn)
