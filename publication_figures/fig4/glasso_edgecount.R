source("../../src/config")
library(igraph)

## get gene names
		# PC corrected
		load("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]
		
plot_edgecounts <- function(tissuename, genes.network.index, gene.symbols.innetwork ){
	fn <- tissuename
	# fn <- "Subcutaneous"

	version.data <- c(pcglasso, half.pcglasso, quarter.pcglasso, exonic.glasso, expeff.glasso, ringlasso, rawglasso)
	edgecounts.network <- vector("list", length = length(version.data))

	for(j in 1:length(version.data)){
		# j = 3
		## load dataset
		print(paste("Loading", version.data[j]))
		load(paste(version.data[j], fn, ".Rdata", sep = ""))
		edgecounts.network[[j]] <- sapply(glasso.network, f <- function(m) {
		    length(which(m!=0))
		}
		)
		# glasso.network <- lapply(glasso.network, function(x,y,z){
		# 	x <- x[z,z]
		# 	x[which(is.na(x))] <- 0
		# 	dimnames(x) <- list(y,y)
		# 	x
		# 	}, gene.symbols.innetwork, genes.network.index)

		# edgecounts.network[[j]] <- sapply(glasso.network, function(x){
		# 	x <- graph_from_adjacency_matrix(x, mode = "undirected", diag = F, weighted = T)
		# 	edge.counts <- ecount(x)
		# 	edge.counts
		# })
		# edgecounts.network[[j]] <- do.call(rbind, edgecounts.network[[j]])
	}
	names(edgecounts.network) <- c("PC-corrected", "half-PC", "quarter-PC", "exonic rate", "expeff", "RIN corrected", "uncorrected")
	edgecounts.network <- do.call(cbind,edgecounts.network)
	rownames(edgecounts.network) <- seq(0.3,1.0,length.out=50)
	melt(edgecounts.network)
}

#### Run function
plot.glasso.thyroid <- plot_edgecounts("Thyroid", genes.network.withnames, pc.gene.symbols)
write.csv(plot.glasso.thyroid, "ecount_glasso_table_thyroid.csv")


plot.glasso.muscle <- plot_edgecounts("Muscle", genes.network.withnames, pc.gene.symbols)
write.csv(plot.glasso.muscle, "ecount_glasso_table_muscle.csv")


plot.glasso.lung <- plot_edgecounts("Lung", genes.network.withnames, pc.gene.symbols)
write.csv(plot.glasso.lung, "ecount_glasso_table_lung.csv")

plot.glasso.blood <- plot_edgecounts("Blood", genes.network.withnames, pc.gene.symbols)
write.csv(plot.glasso.blood, "ecount_glasso_table_blood.csv")

plot.glasso.sub <- plot_edgecounts("Subcutaneous", genes.network.withnames, pc.gene.symbols)
write.csv(plot.glasso.sub, "ecount_glasso_table_sub.csv")

save(plot.glasso.thyroid, plot.glasso.muscle, plot.glasso.lung, plot.glasso.blood, plot.glasso.sub, file = "fig4-glasso.RData")

