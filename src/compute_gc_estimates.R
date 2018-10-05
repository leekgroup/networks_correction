### Load libraries
library(parallel)
library(recount)
library(ggplot2)
library(RColorBrewer)
library(reshape2)
library(cowplot)

# Load/Read data
inputargs <- commandArgs(TRUE)
raw.data <- inputargs[1]
# raw.data <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_rse.Rdata"
gene.gc.fn <- inputargs[2]
save.gc.attached.fn <- inputargs[3]

## Load data and read files
load(raw.data)
gene_gc <- read.delim(gene.gc.fn, header = F, stringsAsFactors = F)

## Fit linear model to get sample specific estimates for effect of GC% on gene expression

gc.fit <- lapply(gtex.rse, function(p,q){
	dat <- SummarizedExperiment::assay(p, 1)
	dim(dat)
	dat <- dat[which(rownames(dat) %in% q$V1),]
	gene_gc_sub <- q[which(q$V1 %in% rownames(dat)),]
	dat <- dat[gene_gc_sub$V1,]
	dim(dat)
	lm.gc.fit <- lm(dat ~ gene_gc_sub$V2)
	lm.gc.fit
	}, gene_gc
	)

## extract p-values from lm fit
pvals <- lapply(gc.fit, function(lm.gc.fit){
	pval <- sapply(summary(lm.gc.fit), function(x) x$coefficients[2,4])
	pval <- pval * length(pval)
	pval
	})

## get coefficients from lm fit
gc.coeff <- lapply(gc.fit, function(each.gc.fit){
 	each.gc.fit$coefficients[2,]
 	})

gtex.rse <- mapply(function(x,y){
		x@colData$gc <- y
		x
		}, gtex.rse, gc.coeff)

#gtex.rse$Subcutaneous@colData$gc <- gc.coeff$Subcutaneous
#gtex.rse$Lung@colData$gc <- gc.coeff$Lung
#gtex.rse$Thyroid@colData$gc <- gc.coeff$Thyroid
#gtex.rse$Muscle@colData$gc <- gc.coeff$Muscle
#gtex.rse$Blood@colData$gc <- gc.coeff$Blood

save(gtex.rse, file = save.gc.attached.fn)
