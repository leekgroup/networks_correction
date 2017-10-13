##### Get merged canonical list

rm(list = ls())
library(igraph)
library(recount)
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

load("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

		## count overlapping genesets
		missing.genes <- all.genes.inset[which(!all.genes.inset %in% pc.gene.symbols)]
		tp.fn <- delete_vertices(tp.fn, missing.genes)
		canonical.merged <- get.edgelist(tp.fn)
		write.table(canonical.merged, file = "canonical_merged.txt", quote = F)

#### Get kegg
rm(list=ls())
library(recount)
library(igraph)
kegg <- read.delim("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/genesets/kegg2016.txt",
	header = F, stringsAsFactors = F, row.names = 1)
kegg$V2 <- NULL
names.gsets <- rownames(kegg)
kegg <- t(kegg)
kegg <- sapply(kegg, function(x) strsplit(x,',')[[1]])
names(kegg) <- names.gsets
kegg <- lapply(kegg, sort)
all.genes.inset <- unlist(kegg)
names(all.genes.inset) <- NULL
kegg <- lapply(kegg, function(x){
	g <- make_full_graph(length(x))
	V(g)$name <- x
	get.edgelist(g)
	})
kegg <- do.call(rbind, kegg)
kegg <- unique(data.frame(kegg))
tp.fn <- graph.data.frame(kegg, directed = FALSE)

load("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

		## count overlapping genesets
		missing.genes <- all.genes.inset[which(!all.genes.inset %in% pc.gene.symbols)]
		tp.fn <- delete_vertices(tp.fn, missing.genes)
		kegg.list <- get.edgelist(tp.fn)
		write.table(kegg.list, file = "kegg.txt", quote = F)


#### Get biocarta
rm(list=ls())
library(recount)
library(igraph)
biocarta <- read.delim("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/genesets/biocarta2016.txt",
	header = F, stringsAsFactors = F, row.names = 1)
biocarta$V2 <- NULL
names.gsets <- rownames(biocarta)
biocarta <- t(biocarta)
biocarta <- sapply(biocarta, function(x) strsplit(x,',')[[1]])
names(biocarta) <- names.gsets
biocarta <- lapply(biocarta, sort)
all.genes.inset <- unlist(biocarta)
names(all.genes.inset) <- NULL
biocarta <- lapply(biocarta, function(x){
	g <- make_full_graph(length(x))
	V(g)$name <- x
	get.edgelist(g)
	})
biocarta <- do.call(rbind, biocarta)
biocarta <- unique(data.frame(biocarta))
tp.fn <- graph.data.frame(biocarta, directed = FALSE)

load("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

		## count overlapping genesets
		missing.genes <- all.genes.inset[which(!all.genes.inset %in% pc.gene.symbols)]
		tp.fn <- delete_vertices(tp.fn, missing.genes)
		biocarta.list <- get.edgelist(tp.fn)
		write.table(biocarta.list, file = "biocarta.txt", quote = F)



#### Get PID
rm(list=ls())
library(recount)
library(igraph)
pid <- read.delim("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/genesets/pid2016.txt",
	header = F, stringsAsFactors = F, row.names = 1)
pid$V2 <- NULL
names.gsets <- rownames(pid)
pid <- t(pid)
pid <- sapply(pid, function(x) strsplit(x,',')[[1]])
names(pid) <- names.gsets
pid <- lapply(pid, sort)
all.genes.inset <- unlist(pid)
names(all.genes.inset) <- NULL
pid <- lapply(pid, function(x){
	g <- make_full_graph(length(x))
	V(g)$name <- x
	get.edgelist(g)
	})
pid <- do.call(rbind, pid)
pid <- unique(data.frame(pid))
tp.fn <- graph.data.frame(pid, directed = FALSE)

load("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

		## count overlapping genesets
		missing.genes <- all.genes.inset[which(!all.genes.inset %in% pc.gene.symbols)]
		tp.fn <- delete_vertices(tp.fn, missing.genes)
		pid.list <- get.edgelist(tp.fn)
		write.table(pid.list, file = "pid.txt", quote = F)


#### Get reactome
rm(list=ls())
library(recount)
library(igraph)
reactome <- read.delim("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/genesets/reactome2016.txt",
	header = F, stringsAsFactors = F, row.names = 1)
reactome$V2 <- NULL
names.gsets <- rownames(reactome)
reactome <- t(reactome)
reactome <- sapply(reactome, function(x) strsplit(x,',')[[1]])
names(reactome) <- names.gsets
reactome <- lapply(reactome, sort)
all.genes.inset <- unlist(reactome)
names(all.genes.inset) <- NULL
reactome <- lapply(reactome, function(x){
	g <- make_full_graph(length(x))
	V(g)$name <- x
	get.edgelist(g)
	})
reactome <- do.call(rbind, reactome)
reactome <- unique(data.frame(reactome))

tp.fn <- graph.data.frame(reactome, directed = FALSE)

load("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/data/gtex_half_pc_corrected.Rdata")
		###**** REMEMBER 1 is hard coded in the next line ****###
		pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
		genes.network.withnames <- which(!is.na(pc.gene.symbols))
		pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

		## count overlapping genesets
		missing.genes <- all.genes.inset[which(!all.genes.inset %in% pc.gene.symbols)]
		tp.fn <- delete_vertices(tp.fn, missing.genes)
		reactome.list <- get.edgelist(tp.fn)
		write.table(reactome.list, file = "reactome.txt", quote = F)
