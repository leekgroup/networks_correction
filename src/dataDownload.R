rm(list=ls())

## load libraries
library(recount)


source("functions.R")
source("config.R")

## create dir
dir.create(datDir)

## download and scale reads
download_study('SRP012682', type = 'rse-gene', outdir = datDir)
load(paste(datDir, "rse_gene.Rdata", sep = ""))
tissue.interest <- c("Subcutaneous", "Lung", "Thyroid", "Muscle", "Blood")

## scale counts by total coverage of the sample
rse_gene <- scale_counts(rse_gene, by = "auc", round = FALSE)

## select samples included in analysis freeze
rse_gene <- rse_gene[,which(colData(rse_gene)$smafrze=="USE ME")]

## only keep protein coding genes
pc.genes <- read.delim(paste(homeDir, "etc/protein_coding.txt", sep = ""), header = F)
rse_gene <- rse_gene[which(rownames(rse_gene) %in% pc.genes$V2),]


## summary
print(paste("Unique runs", length(unique(colData(rse_gene)$run))))
print(paste("Unique sample ids",length(unique(colData(rse_gene)$sampid))))
print(paste("Are all run values in phenotypes same order as colnames in rse_gene?", all(colData(rse_gene)$run==colnames(rse_gene))))

## split rse object
print(paste("Now splitting rse object by tissues"))

gtex.rse <- sapply(tissue.interest, function(x, y){
  idx <- grep(x, colData(y)$smtsd)
  rse.dat <- y[,idx]
  rse.dat <- select.genes(rse.object = rse.dat, threshold = 0.1)
  counts <- SummarizedExperiment::assay(rse.dat, 1)
  # log2 transformation 
  SummarizedExperiment::assay(rse.dat, 1) <- log2(counts+2)
  rse.dat
}, rse_gene)

rm(rse_gene)

## select only those thyroid samples that have genotype information
#sampid <- as.character(sapply(colData(gtex.rse[["Thyroid"]])$sampid, function(x){ 
#k <-strsplit(x, '-')
#k <- paste(k[[1]][1],k[[1]][2], sep = ".")
#k
#}
#)
#)
#genotype.samples <- read.delim("genotype_samples.txt")
#dim(gtex.rse[["Thyroid"]])
#gtex.rse[["Thyroid"]] <- gtex.rse[["Thyroid"]][,which(sampid %in% colnames(genotype.samples))]

## tissue specific data summary
print(paste("Number of genes,samples:"))
for(i in 1:length(gtex.rse)){
  print(paste(names(gtex.rse)[i]))
  print(paste(dim(gtex.rse[[i]])))
}

## save rdata - adipose sub, lung, thyroid, whole Blood
save(gtex.rse, file = paste(datDir, "raw_protein_coding.Rdata",sep = ""))
