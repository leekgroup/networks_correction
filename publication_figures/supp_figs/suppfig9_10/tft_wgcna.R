source("../../src/config")
library(igraph)

## process the total list of true positives and false negatives --> total gene-gene pairs from the genesets
## read genesets of interest
g.sets <- read.delim("/work-zfs/abattle4/parsana/networks_correction/data/genesets/tft.txt", header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL
names.gsets <- sapply(rownames(g.sets), function(x) strsplit(x,'_')[[1]][1])
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) strsplit(x,',')[[1]])
names(g.sets) <- names.gsets
g.sets <- melt(g.sets)
g.sets <- unique(data.frame(g.sets))
tp.fn <- graph.data.frame(g.sets, directed = FALSE)
all.genes.inset <- V(tp.fn)$name

## get gene names
		# PC corrected
		load("/work-zfs/abattle4/parsana/networks_correction/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

		## count overlapping genesets
		missing.genes <- all.genes.inset[which(!all.genes.inset %in% pc.gene.symbols)]
		tp.fn <- delete_vertices(tp.fn, missing.genes)
		count.tp.fn <- ecount(tp.fn)
		
plot_precision_recall <- function(tissuename, truep.falsen, genes.network.index, gene.symbols.innetwork ){
	fn <- tissuename
	# fn <- "Subcutaneous"

	## for each dataset
	precision <- matrix(ncol = 5, nrow = 50)
	recall <- matrix(ncol = 5, nrow = 50)

	version.data <- c(pc, half.pc, quarter.pc, rin, raw)
	for(j in 1:length(version.data)){
		load(paste(version.data[j],"wgcna_networks.RData", sep = ""))
		wgcna.networks <- wgcna.networks[[fn]]
		modules.genes <- vector("list",length=length(wgcna.networks))
		networks.list <- vector("list",length=length(wgcna.networks))
		# tp.fp <- vector("numeric", length = length(wgcna.networks))
		for(i in 1:length(wgcna.networks)){
			modules.genes[[i]] <- sapply(sort(unique(wgcna.networks[[i]]$colors))[-1], function(x,y,z,q){
				y.withgenenames <- y$colors[z]
				q[which(y.withgenenames == x)]
					}, wgcna.networks[[i]], genes.network.index, gene.symbols.innetwork)

			## convert modules to fully connected graph
			networks.list[[i]] <- lapply(modules.genes[[i]], function(x){
			g <- make_full_graph(length(x))
			V(g)$name <- x
			get.edgelist(g)
			})

			networks.list[[i]] <- do.call(rbind, networks.list[[i]])
			networks.list[[i]] <- unique(data.frame(networks.list[[i]]))
			networks.list[[i]] <- graph.data.frame(networks.list[[i]], directed = FALSE)
			# rm(networks.list)
		}
		
		precision.recall <- sapply(networks.list, function(x,y){
			tp <- ecount(graph.intersection(x,y))
			fp <- ecount(graph.difference(x,y))
			fn <- ecount(y) - tp
			precision.infunc <- tp/(tp+fp)
			recall.infunc <- tp/(tp+fn)
			return(c(precision.infunc, recall.infunc))
			}, truep.falsen)

		precision[,j] <- precision.recall[1,]
		recall[,j] <- precision.recall[2,]
	}
	colnames(precision) <- c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected")
	rownames(precision) <- cutheights
	plot.precision <- melt(precision)

	colnames(recall) <- c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected")
	rownames(recall) <- cutheights
	plot.recall <- melt(recall)

	plot.both <- cbind(plot.precision, plot.recall[,3])
	colnames(plot.both) <- c("Cutheights", "type", "precision", "recall")
	plot.both
}

#### Run function
plot.thyroid <- plot_precision_recall("Thyroid", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.muscle <- plot_precision_recall("Muscle", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.lung <- plot_precision_recall("Lung", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.blood <- plot_precision_recall("Blood", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.sub <- plot_precision_recall("Subcutaneous", tp.fn, genes.network.withnames, pc.gene.symbols)

save(plot.thyroid, plot.muscle, plot.lung, plot.blood, plot.sub, file = "tft-wgcna.RData")
