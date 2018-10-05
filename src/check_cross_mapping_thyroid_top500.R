# rm(list = ls())

setwd("/work-zfs/abattle4/parsana/networks_correction/")

library(reshape2)
library(dplyr)
library(ggplot2)
library(recount)

inputargs <- commandArgs(TRUE)
tiss <- "Thyroid"
pathways.fn <- "data/genesets/canonical_pathways_merged.txt"


# get gene ids - symbol mapping from recount dataset

load("data/raw_subset.Rdata")
dat.gene.symbol <- rowData(dat.expr[[tiss]])
head(dat.gene.symbol)

# get indices of overlapping ids
o_id <- read.delim("data/etc/ensembl_ids_overlapping_genes.txt", stringsAsFactors = F)
rm_id = which(dat.gene.symbol$gene_id %in% o_id$x)
dat.gene.symbol <- dat.gene.symbol[-rm_id,]
g_symbol <- sapply(dat.gene.symbol$symbol, function(x) x[1])
dat.gene.symbol <- data.frame(gene_id = dat.gene.symbol$gene_id, gene_symbol = g_symbol, stringsAsFactors = F)
rm(dat.expr)

## Read genesets
g.sets <- read.delim(pathways.fn, header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL # second column is NA
names.gsets <- rownames(g.sets)
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) sort(strsplit(x,',')[[1]]))
names(g.sets) <- names.gsets
# all.genes.inset <- unlist(g.sets)
# names(all.genes.inset) <- NULL
# all.genes.inset <- unique(all.genes.inset)
# all.genesinset.subset <- all.genes.inset[which(all.genes.inset %in% dat.gene.symbol$gene_symbol)] # This is the intersection of all genes in our analysis also present in the genesets and pathways we are using to evaluate the networks

## select genes in pathways that are also present in the set of variable genes
genes.inpathways <- lapply(g.sets, function(x,y){
  genes.inset <- x[which(x %in% y)]
  genes.inset
}, dat.gene.symbol$gene_symbol)

unique.gene.symbols.inpathways <- unique(unlist(genes.inpathways))

true.positive.list <- lapply(genes.inpathways, function(x){
  if(length(x) > 1){
    pathway.edge <- t(combn(sort(x),2))
    pathway.edge <- paste(pathway.edge[,1], pathway.edge[,2], sep = "_")
  }else{
    pathway.edge <- NA
  }
  pathway.edge
})

true.positive.list <- unique(unlist(true.positive.list))
true.positive.list <- true.positive.list[which(!is.na(true.positive.list))]
print("Total real edgelist size:")
print(length(true.positive.list))



get_networks <- function(tiss, dat.gene.symbol){
  type.exp <- c("raw", "pc")
  tiss.net <- lapply(type.exp, function(x,y,z, r){
    print(paste("Loading dataset", x))
    load(paste("networks", x, "correlation_networks.Rdata", sep = "/"))
    dat.net <- dat.net[[y]]
    dat.net <- dat.net[-r,-r]
    if(all(sub('(^[^.]+)\\.(.*)$','\\1',colnames(dat.net),"") == z$gene_id)){
      rownames(dat.net) <- z$gene_symbol
      colnames(dat.net) <- z$gene_symbol
      sorted.gene.order <- order(rownames(dat.net))
      dat.net <- dat.net[sorted.gene.order, sorted.gene.order]
    }else{
      print("Gene order and mapping error. Please manually check!")
    }
    diag(dat.net) <- NA
    dat.net[lower.tri(dat.net)] <- NA
    dat.net <- melt(dat.net, na.rm = T)
    dat.net$edge <- paste(dat.net$Var1, dat.net$Var2, sep = "_")
    dat.net <- dat.net[which(!is.na(dat.net$Var2)),]
    dat.net <- arrange(dat.net, desc(value))
    print(head(dat.net))
    dat.net
  },tiss, dat.gene.symbol, rm_id)
}

thyroid.nets <- get_networks(tiss = "Thyroid", dat.gene.symbol = dat.gene.symbol)
lung.nets <- get_networks(tiss = "Lung", dat.gene.symbol = dat.gene.symbol)
# load("../temp/lung_thyroid.Rdata")
th = seq(100,5000, 100)

thyroid.nets.th <- lapply(thyroid.nets, function(x,y,z){
  sapply(y, function(a,b,c){
    length(intersect(b$edge[1:a], c))/a
  }, x, z)
}, th, true.positive.list)

names(thyroid.nets.th) <- c("raw","pc")
plot_thyroid  <- melt(thyroid.nets.th)
plot_thyroid$th <- rep(th, 2)
colnames(plot_thyroid) <- c("True_positive_ratio", "Type", "Threshold")

thyroidp <- ggplot(plot_thyroid, aes(x = Threshold, y=True_positive_ratio, col = Type))+geom_point()
ggsave(thyroidp, file = "../temp/remove_overlap_thyroid_tp_ratio.pdf")

lung.nets.th <- lapply(lung.nets, function(x,y,z){
  sapply(y, function(a,b,c){
    length(intersect(b$edge[1:a], c))/a
  }, x, z)
}, th, true.positive.list)

names(lung.nets.th) <- c("raw","pc")
plot_lung  <- melt(lung.nets.th)
plot_lung$th <- rep(th, 2)

colnames(plot_lung) <- c("True_positive_ratio", "Type", "Threshold")

lungp <- ggplot(plot_lung, aes(x = Threshold, y=True_positive_ratio, col = Type))+geom_point()
ggsave(lungp, file = "../temp/remove_overlap_lungp_tp_ratio.pdf")

cm_genes <- readRDS("../temp/cross_mapping_protein_coding.RDS")

top100.thyroid <- lapply(thyroid.nets, function(x,y,z,cm){
x <- x[1:500,]
x$inpathway <- ifelse(x$edge %in% y, "yes", "no")
x <- left_join(x, z, by = c("Var1" = "gene_symbol"))
x <- left_join(x, z, by = c("Var2" = "gene_symbol"))
t <- t(apply(x[,c("gene_id.x", "gene_id.y")], 1, sort))
x$edge_id<- paste(t[,1], t[,2], sep = "_")
x$cross_mapping <- ifelse(x$edge_id %in% cm$edges, "yes", "no")
x
}, true.positive.list, dat.gene.symbol, cm_genes)

write.csv(top100.thyroid[[1]], file = "raw_thyroid_top500.csv")
write.csv(top100.thyroid[[2]], file = "pc_thyroid_top500.csv")
# top100.lung <- lapply(lung.nets, function(x,y){
# x <- x[1:300,]
# x$inpathway <- ifelse(x$edge %in% y, "yes", "no")
# x
# }, true.positive.list)




# thyroid_pc_corr_missing_raw <- top100.thyroid[[2]][which(top100.thyroid[[2]]$edge %in% setdiff(top100.thyroid[[2]]$edge, top100.thyroid[[1]]$edge)),]



# ### test correlation between pairs for zaitlen hypothesis
# source("../networks_correction/src/functions.R")
# load("../networks_correction/data/raw_subset.Rdata")
# # dat.expr <- lapply(dat.expr, function(x){
# #     x <- q_normalize(x)
# #     x
# #   })
# thyroid_raw_exp <- dat.expr$Thyroid
# load("../networks_correction/data/pc_loadings.Rdata")
# load("../networks_correction/data/pc_corrected.Rdata")
# # dat.expr <- lapply(dat.expr, function(x){
# #     x <- q_normalize(x)
# #     x
# #   })
# thyroid_pc_exp <- dat.expr$Thyroid

# thyroid_loadings <- pc.loadings$Thyroid[,1:38]
# goi <- goi <- as.list(data.frame(t(thyroid_pc_corr_missing_raw[,c("Var1","Var2")]), stringsAsFactors = F))

# corr_pc = lapply(goi, function(x,y,z,w, v){
#   eid <- y$gene_id[which(y$gene_symbol %in% x)]
#   raw_exp <- t(z[grep(paste(eid, collapse = "|"), rownames(z)),]@assays$data$counts)
#   pc_exp <- t(w[grep(paste(eid, collapse = "|"), rownames(w)),]@assays$data$counts)
#   raw_pc_correlation <- round(apply(abs(cor(raw_exp, v)), 1, max),3)
#   raw_correlation <- round(abs(cor(raw_exp[,1], raw_exp[,2])), 3)
#   pc_correlation <- round(abs(cor(pc_exp[,1], pc_exp[,2])), 3)
#   d = list(paste(colnames(pc_exp)[1], colnames(pc_exp)[2], sep = "_"),raw_pc_correlation, raw_correlation, pc_correlation)
#   # d  = c(raw_pc_correlation, raw_correlation, pc_correlation)
#   # names(d) <- c(eid, "raw_pairs", "pc_pairs")
#   d
#   },dat.gene.symbol, thyroid_raw_exp, thyroid_pc_exp, thyroid_loadings )

# corr_pc <- do.call(rbind,lapply(corr_pc, unlist))

