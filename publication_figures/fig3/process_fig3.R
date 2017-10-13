begin.time <- Sys.time()
source("../../src/config")
library(igraph)

## process the total list of true positives and false negatives --> total gene-gene pairs from the genesets
## read genesets of interest
g.sets <- read.delim("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/genesets/canonical_pathways_merged.txt", header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL
names.gsets <- rownames(g.sets)
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) strsplit(x,',')[[1]])
names(g.sets) <- names.gsets
g.sets <- lapply(g.sets, sort)
all.genes.inset <- unlist(g.sets)
names(all.genes.inset) <- NULL
g.sets <- lapply(g.sets, function(x){
	g <- make_full_graph(length(x))
	V(g)$name <- x
	get.edgelist(g)
	})
g.sets <- do.call(rbind, g.sets)
g.sets <- unique(data.frame(g.sets))
tp.fn <- graph.data.frame(g.sets, directed = FALSE)

## get gene names
		# PC corrected
		load("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

		## count overlapping genesets
		missing.genes <- all.genes.inset[which(!all.genes.inset %in% pc.gene.symbols)]
		tp.fn <- delete_vertices(tp.fn, missing.genes)
		count.tp.fn <- ecount(tp.fn)
		
		# tp.fp <- make_full_graph(length(which(!is.na(pc.gene.symbols))))
		# V(tp.fp)$name <- pc.gene.symbols[which(!is.na(pc.gene.symbols))]
		# count.tp.fp <- ecount(tp.fp)
		# rm(tp.fp)


plot_precision_recall <- function(tissuename, truep.falsen, genes.network.index, gene.symbols.innetwork ){
	fn <- tissuename
	# fn <- "Subcutaneous"

	version.data <- c(pcglasso, half.pcglasso, quarter.pcglasso, exonic.glasso, expeff.glasso, ringlasso, gcglasso, rawglasso)
	## for each dataset
        precision <- matrix(ncol = length(version.data), nrow = 50)
        recall <- matrix(ncol = length(version.data), nrow = 50)

	for(j in 1:length(version.data)){
		# j = 3
		## load dataset
		load(paste(version.data[j], fn, ".Rdata", sep = ""))
		glasso.network <- lapply(glasso.network, f <- function(m) {
		    m[lower.tri(m)] <- t(m)[lower.tri(m)]
		    m
		}
		)
		glasso.network <- lapply(glasso.network, function(x,y,z){
			x <- x[z,z]
			x[which(is.na(x))] <- 0
			dimnames(x) <- list(y,y)
			x
			}, gene.symbols.innetwork, genes.network.index)

		precision.recall <- sapply(glasso.network, function(x,y){
			x <- graph_from_adjacency_matrix(x, mode = "undirected", diag = F, weighted = T)
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

	colnames(precision) <- c("PC corrected","half-PC","quarter-PC", "exonic rate", "expeff", "RIN", "gene GC%", "uncorrected")
	rownames(precision) <- lambda
	plot.precision <- melt(precision)

	colnames(recall) <- c("PC corrected","half-PC","quarter-PC", "exonic rate", "expeff", "RIN", "gene GC%", "uncorrected")
	rownames(recall) <- lambda
	plot.recall <- melt(recall)

#	ggplot(plot.precision, aes(x = Var1, y = value, colour = Var2)) + geom_line() + 
#	xlab("Penalty parameter") + ylab("Precision") + 
#	ggtitle(paste("Precision with increasing penalty parameter in graphical lasso", fn, sep = ":"))
#	ggsave(paste("../plots/igraph_",fn, "_precision.png", sep = ""))

	# ggplot(plot.recall, aes(x = Var1, y = value, colour = Var2)) + geom_line() + 
	# xlab("Penalty parameter") + ylab("Recall")
	# ggsave(paste(fn, "_recall.png", sep = ""))

	plot.both <- cbind(plot.precision, plot.recall[,3])
	colnames(plot.both) <- c("lambda", "type", "precision", "recall")
	plot.both
	# both
	# ggplot(plot.both, aes(x = recall, y = precision, colour = type)) + geom_point() + theme_classic() + theme(text = element_text(size=20))+
	# xlab("recall") + ylab("precision")+ggtitle(fn)
	# ggsave(paste("../plots/igraph_",fn, "_precision_recall.png", sep = ""))
}

plot.thyroid <- plot_precision_recall("Thyroid", tp.fn, genes.network.withnames, pc.gene.symbols)
write.csv(plot.thyroid, "pr_table_thyroid.csv")
#plot.thyroid <- ggplot(plot.thyroid, aes(x = recall, y = precision, colour = type)) + geom_point() + theme_classic() + theme(text = element_text(size=20))+
#	xlab("recall") + ylab("precision")+ggtitle("Thyroid")

plot.muscle <- plot_precision_recall("Muscle", tp.fn, genes.network.withnames, pc.gene.symbols)
write.csv(plot.muscle, "pr_table_muscle.csv")
#plot.muscle <- ggplot(plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point() + theme_classic() + theme(text = element_text(size=20))+
#	xlab("recall") + ylab("precision")+ggtitle("Muscle - Skeletal")

plot.lung <- plot_precision_recall("Lung", tp.fn, genes.network.withnames, pc.gene.symbols)
write.csv(plot.lung, "pr_table_lung.csv")
#plot.lung <- ggplot(plot.lung, aes(x = recall, y = precision, colour = type)) + geom_point() + theme_classic() + theme(text = element_text(size=20))+
#	xlab("recall") + ylab("precision")+ggtitle("Lung")

plot.blood <- plot_precision_recall("Blood", tp.fn, genes.network.withnames, pc.gene.symbols)
write.csv(plot.blood, "pr_table_blood.csv")
#plot.blood <- ggplot(plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point() + theme_classic() + theme(text = element_text(size=20))+
#	xlab("recall") + ylab("precision")+ggtitle("Whole Blood")

plot.sub <- plot_precision_recall("Subcutaneous", tp.fn, genes.network.withnames, pc.gene.symbols)
write.csv(plot.sub, "pr_table_sub.csv")
#plot.sub <- ggplot(plot.sub, aes(x = recall, y = precision, colour = type)) + geom_point() + theme_classic() + theme(text = element_text(size=20))+
#	xlab("recall") + ylab("precision")+ggtitle("Adipose - Subcutaneous")

save(plot.thyroid, plot.muscle, plot.lung, plot.blood, plot.sub, file = "fig3.RData")
print(Sys.time() - begin.time)
