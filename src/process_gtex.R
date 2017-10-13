## PC correct gtex tissues and select n most variable genes for network learning

## set wd
rm(list=ls())

setwd("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/")
input.args <- commandArgs(TRUE)
inputargs <- 5000

## get libraries and functions
library("recount")
source("src/functions.R")

## load data
load("data/gtex_rse.Rdata")

## select n most variable genes
num.variables <- inputargs[1]
gtex.rse.sub <- variable.selection.average(gtex.rse, num.variables)
	#gtex.rse.sub <- mclapply(gtex.rse, function(rse){
	#  rse <- variable.selection(rse, num.variables)
	#  rse
	#})

## save gene names
gene.ids <- rownames(gtex.rse.sub[[1]])
write.csv(gene.ids, file ="data/etc/variable_genes_selected.csv", row.names = F, quote = F)

## pca correction
print(names(gtex.rse))
num.pc.estimates <- lapply(gtex.rse,pc.estimate)
print(num.pc.estimates)
gtex.pc.corrected <- mcmapply(pc.correct, gtex.rse, num.pc.estimates, less.pc = F, alt.pc = F)

## half-pc correction
gtex.half.pc.corrected <- mcmapply(pc.correct, gtex.rse, num.pc.estimates, less.pc = T, alt.pc = F, frac = 0.5)

## quarter pc correction
gtex.quarter.pc.corrected <- mcmapply(pc.correct, gtex.rse, num.pc.estimates, less.pc = T, alt.pc = F, frac = 0.25)

## split PC corrected data with variable genes
gtex.pc.corrected <- mclapply(gtex.pc.corrected, function(x,gids){
  gtex.sub <- x[which(rownames(x) %in% gids),]
  gtex.sub
  }, gene.ids)

gtex.half.pc.corrected <- mclapply(gtex.half.pc.corrected, function(x,gids){
  gtex.sub <- x[which(rownames(x) %in% gids),]
  gtex.sub
  }, gene.ids)

gtex.quarter.pc.corrected <- mclapply(gtex.quarter.pc.corrected, function(x,gids){
  gtex.sub <- x[which(rownames(x) %in% gids),]
  gtex.sub
  }, gene.ids)


## thyroid - exclude PCs of interest
#thyroid.alternate.pc <- pc.correct(gtex.rse$Thyroid, num.pc.estimates$Thyroid, less.pc = F, alt.pc = T, rm.pc = c(2,4,7,16))
#thyroid.alternate.pc <- thyroid.alternate.pc[which(rownames(thyroid.alternate.pc) %in% gene.ids),] ## select variable genes

## thyroid - exclude only foxe1 pcs
#thyroid.foxe.pc <- pc.correct(gtex.rse$Thyroid, num.pc.estimates$Thyroid, less.pc = F, alt.pc = T, rm.pc = c(4,6))
#thyroid.foxe.pc <- thyroid.foxe.pc[which(rownames(thyroid.alternate.pc) %in% gene.ids),] ## select variable genes

# GC content correction
gc_estimate <- "/scratch/groups/abattle4/princy/claire_network/Network-Inference/gtex_networks/publication_rmd/gene_gc_content/gc_estimate_sample.RData"
load(gc_estimate)


gtex.rse.gc <- mapply(function(x,y){
	expr.dat <- t(SummarizedExperiment::assay(x, 1))
	SummarizedExperiment::assay(x, 1) <- t(lm(expr.dat~y)$residuals)
	x
	}, gtex.rse.sub, gc.coeff)

save(gtex.rse.gc, file = "/scratch/groups/abattle4/princy/claire_network/Network-Inference/gtex_networks/data/gtex_gc.RData")


# RIN correct
gtex.rse.rin <- mclapply(gtex.rse.sub, covcorrect, "smrin")

# Exonic rate correction
gtex.rse.exon <- mclapply(gtex.rse.sub, covcorrect,"smexncrt")

# expression profiling efficiency
gtex.rse.expeff <- mclapply(gtex.rse.sub, covcorrect,"smexpeff")

## save objects

# raw
save(gtex.rse.sub, file = "data/raw_subset.Rdata")

# rin
save(gtex.rse.rin, file = "data/gtex_rin_corrected.Rdata")

# exonic rate
save(gtex.rse.exon, file = "data/gtex_exon.Rdata")

#expeff
save(gtex.rse.expeff, file = "data/gtex_expeff.Rdata")

# pc corrected
save(gtex.pc.corrected, file = "data/gtex_pc_corrected.Rdata")
save(gtex.half.pc.corrected, file = "data/gtex_half_pc_corrected.Rdata")
save(gtex.quarter.pc.corrected, file = "data/gtex_quarter_pc_corrected.Rdata")

# alt thyroid
#save(thyroid.alternate.pc, file = "data/thyroid_alternate.Rdata")
#save(thyroid.foxe.pc, file = "data/thyroid_foxe.Rdata")
