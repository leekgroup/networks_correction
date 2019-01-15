library(cowplot)
library(ggplot2)
library(parallel)
library(igrpah)
library(reshape2)
theme_set(theme_cowplot(font_size=9))

create.igraph <- function(network){
    # network[which(network != 0)] <- 1
    diag(network) <- 0
    network[network!=0] <- 1
    graph_from_adjacency_matrix(network, mode = "undirected")
}


fn <- dir("networks/", recursive=T, full.names = T)
fn <- fn[grep("glasso", fn)]

igraph_net <- mclapply(fn, function(x){
	load(x)
	net.igraph <- lapply(dat.net, function(eachNet){
		eachNet[lower.tri(eachNet)] <- t(eachNet)[lower.tri(eachNet)]
		create.igraph(eachNet)
		})
	net.igraph
	}, mc.cores = 16)

igraph_net <- lapply(igraph_net, function(x,y){
	y <- y
	this_net <- lapply(x, function(thisx, thisy){
		V(thisx)$name <- thisy
		thisx
		}, y)
	this_net
	}, dat.gene.symbol$gene_symbol)

cc_net <- mclapply(igraph_net, function(x)
		sapply(x, transitivity), mc.cores = 16)

nodes_with_20 <- mclapply(igraph_net, function(x)
		sapply(x, function(y) sum(degree(y) >=20)), mc.cores = 16)

names(cc_net) <- fn
	
raw <- cc_net[grep("raw", fn)]
rin <- cc_net[grep("rin", fn)]
exonicrate <- cc_net[grep("exonicRate", fn)]
gc <- cc_net[grep("gc", fn)]
mc <- cc_net[grep("mc", fn)]
quarter <- cc_net[grep("quarter", fn)]
half <- cc_net[grep("half", fn)]
pc <- cc_net[grep("/pc/", fn)]

melt_cc_net <- melt(data.frame(raw, rin, exonicrate, gc, mc, quarter, half, pc))

melt_cc_net$tissue <- NA
melt_cc_net$tissue[grep("Artery", melt_cc_net$variable)] <- "Tibial Artery"
melt_cc_net$tissue[grep("Blood", melt_cc_net$variable)] <- "Whole Blood"
melt_cc_net$tissue[grep("Lung", melt_cc_net$variable)] <- "Lung"
melt_cc_net$tissue[grep("Muscle", melt_cc_net$variable)] <- "Muscle"
melt_cc_net$tissue[grep("Subcutaneous", melt_cc_net$variable)] <- "Adipose Subcutaneous"
melt_cc_net$tissue[grep("Nerve", melt_cc_net$variable)] <- "Nerve Tibial"
melt_cc_net$tissue[grep("Thyroid", melt_cc_net$variable)] <- "Thyroid"
melt_cc_net$tissue[grep("Skin", melt_cc_net$variable)] <- "Sun exposed Skin"

melt_cc_net$version <- NA
melt_cc_net$version[grep("raw", melt_cc_net$variable)] <- "Uncorrected"
melt_cc_net$version[grep("rin", melt_cc_net$variable)] <- "RIN"
melt_cc_net$version[grep("exonic", melt_cc_net$variable)] <- "exonic rate"
melt_cc_net$version[grep("gc", melt_cc_net$variable)] <- "gene GC%"
melt_cc_net$version[grep("mc", melt_cc_net$variable)] <- "multi-covariate"
melt_cc_net$version[grep("quarter", melt_cc_net$variable)] <- "quarter-PC"
melt_cc_net$version[grep("half", melt_cc_net$variable)] <- "half-PC"
melt_cc_net$version[grep("..pc.", melt_cc_net$variable)] <- "PC"


select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$version %in% category_name),]
  pr_table$version <- factor(pr_table$version, levels = category_name)
  pr_table
}

which_version <- c("Uncorrected", "RIN", "multi-covariate", "PC")

plot_this <- select_category(which_version, melt_cc_net)

thisplot <- ggplot(aes(y = value, x = tissue, fill = version), 
	data = plot_this)+
geom_boxplot()+ ylab("Clustering coefficient")+ xlab("Tissue") + theme_classic()+theme(axis.text.x = element_text(angle = 90, hjust = 1))

pdf("suppfig12.pdf", height = 7, width = 12)
print(thisplot)
dev.off()

