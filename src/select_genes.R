## Select variable genes across 5 tissues in the study

source("functions.R")
source("config.R")

# input arguments to the script
inputargs <- commandArgs(TRUE)
raw.file <- inputargs[1]
num.genes <- as.numeric(inputargs[2])
save.gid.fn <- inputargs[3]
save.subset.fn <- inputargs[4]
# inputargs <- 5000

## load data
load(raw.file)

## select n most variable genes
dat.expr <- variable.selection.average(rse.object = gtex.rse, n = num.genes)

## Check if variable names in all tissues are in the same order
paste("Checking if gene names in all tissues are in the same order: ")
paste("Lung and Sub")
all(rownames(dat.expr$Lung) == rownames(dat.expr$Subcutaneous))
paste("Lung and Muscle")
all(rownames(dat.expr$Lung) == rownames(dat.expr$Muscle))
paste("Lung and Blood")
all(rownames(dat.expr$Lung) == rownames(dat.expr$Blood))
paste("Lung and Thyroid")
all(rownames(dat.expr$Lung) == rownames(dat.expr$Thyroid))

## save gene names
gene.ids <- rownames(dat.expr$Lung)
write.csv(gene.ids, file = save.gid.fn, row.names = F, quote = F)

## save subsetted file
save(dat.expr, file = save.subset.fn)
