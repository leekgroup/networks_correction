source("../../src/config")
library(igraph)

## get gene names
		# PC corrected
		load("/work-zfs/abattle4/parsana/networks_correction/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]
		
plot_edgecounts <- function(tissuename, genes.network.index, gene.symbols.innetwork ){
	fn <- tissuename
	# fn <- "Subcutaneous"
	version.data <- c(pc, half.pc, quarter.pc, rin, raw)

	edgecounts.network <- vector("list", length = 5)
	for(j in 1:length(version.data)){
		load(paste(version.data[j],"wgcna_networks.RData", sep = ""))
		wgcna.networks <- wgcna.networks[[fn]]

		edgecounts.network[[j]] <- lapply(wgcna.networks, function(each.network, genes.index, genes.withsymbols){
			modules.genes <- sapply(sort(unique(each.network$colors))[-1], function(x,y,z,q){
				y.withgenenames <- y$colors[z]
				q[which(y.withgenenames == x)]
					}, each.network, genes.index, genes.withsymbols)

			networks.list <- lapply(modules.genes, function(c){
			g <- make_full_graph(length(c))
			V(g)$name <- c
			get.edgelist(g)
			})
			return(mean(sapply(networks.list, nrow)))
		}, genes.network.index, gene.symbols.innetwork)

		edgecounts.network[[j]] <- do.call(rbind, edgecounts.network[[j]])
	}
#	names(edgecounts.network) <- c("PC-corrected", "half-PC", "quarter-PC", "RIN corrected", "Uncorrected")
	edgecounts.network <- do.call(cbind,edgecounts.network)
	colnames(edgecounts.network) <- c("PC-corrected", "half-PC", "quarter-PC", "RIN corrected", "Uncorrected")
	rownames(edgecounts.network) <- seq(0.9,1.0,length.out=50)
	melt(edgecounts.network)
}

#### Run function
plot.wgcna.thyroid <- plot_edgecounts("Thyroid", genes.network.withnames, pc.gene.symbols)
# write.csv(plot.wgcna.thyroid, "ecount_wgcna_table_thyroid.csv")


plot.wgcna.muscle <- plot_edgecounts("Muscle", genes.network.withnames, pc.gene.symbols)
# write.csv(plot.wgcna.muscle, "ecount_wgcna_table_muscle.csv")


plot.wgcna.lung <- plot_edgecounts("Lung", genes.network.withnames, pc.gene.symbols)
# write.csv(plot.wgcna.lung, "ecount_wgcna_table_lung.csv")

plot.wgcna.blood <- plot_edgecounts("Blood", genes.network.withnames, pc.gene.symbols)
# write.csv(plot.wgcna.blood, "ecount_wgcna_table_blood.csv")

plot.wgcna.sub <- plot_edgecounts("Subcutaneous", genes.network.withnames, pc.gene.symbols)
# write.csv(plot.wgcna.sub, "ecount_wgcna_table_sub.csv")

save(plot.wgcna.thyroid, plot.wgcna.muscle, plot.wgcna.lung, plot.wgcna.blood, plot.wgcna.sub, file = "fig4-average-wgcna.RData")


