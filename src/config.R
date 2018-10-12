### config file for standard input parameters ###

## libraries
library(recount)
library("WGCNA") # weighted gene correlation network analysis
library("QUIC") # package for graphical lasso
library("reshape2")
library("BiocParallel")
library("BatchJobs")
library("parallel")
library("ggplot2")

## data directory
homeDir <- "/work-zfs/abattle4/parsana/networks_correction/"
datDir <- paste(homeDir, "data/", sep = "")
networksDir <- paste(homeDir, "networks/", sep = "")


#	raw <- paste(networksDir, "raw/", sep = "")
#		rawglasso <- paste(raw, "glasso/", sep = "")
#	rin <- paste(networksDir, "rin/", sep = "")
#		ringlasso <-"/work-zfs/abattle4/parsana/networks_correction/networks/rin/glasso/"
#	exonic <- "/work-zfs/abattle4/parsana/networks_correction/networks/exonic/"
#		exonic.glasso <- "/work-zfs/abattle4/parsana/networks_correction/networks/exonic/glasso/"
#	gc <- "/work-zfs/abattle4/parsana/networks_correction/networks/gc/"
#		gcglasso <- "/work-zfs/abattle4/parsana/networks_correction/networks/gc/glasso/"
#	multi3 <- "/work-zfs/abattle4/parsana/networks_correction/networks/multi3/"
#		multi3glasso <- "/work-zfs/abattle4/parsana/networks_correction/networks/multi3/glasso/"
#	multicorr <- "/work-zfs/abattle4/parsana/networks_correction/networks/multicorr/"
#		multicorrglasso <- "/work-zfs/abattle4/parsana/networks_correction/networks/multicorr/glasso/"
#	pc <- "/work-zfs/abattle4/parsana/networks_correction/networks/pc_corrected/"
#		pcglasso <- "/work-zfs/abattle4/parsana/networks_correction/networks/pc_corrected/glasso/"
#	half.pc <-"/work-zfs/abattle4/parsana/networks_correction/networks/half_pc_corrected/" 
#		half.pcglasso <- "/work-zfs/abattle4/parsana/networks_correction/networks/half_pc_corrected/glasso/"
#	quarter.pc <- "/work-zfs/abattle4/parsana/networks_correction/networks/quarter_pc_corrected/"
#		quarter.pcglasso <- "/work-zfs/abattle4/parsana/networks_correction/networks/quarter_pc_corrected/glasso/"

# dir.create(netMain)
# dir.create(pc)
# dir.create(pcglasso)
# dir.create(rin)
# dir.create(ringlasso)
# dir.create(raw)
# dir.create(rawglasso)
# dir.create(half.pc)
# dir.create(half.pcglasso)
# dir.create(quarter.pc)
# dir.create(quarter.pcglasso)
# dir.create(exonic)
# dir.create(exonic.glasso)
# dir.create(expeff)
# dir.create(expeff.glasso)
# dir.create(gc)
# dir.create(gcglasso)
# dir.create(multi3)
# dir.create(multi3glasso)
# dir.create(multicorr)
# dir.create(multicorrglasso)
## PC corrected data
#pc.corrected <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_pc_corrected.Rdata"


## half PC corrected data
#half.pc.corrected <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_half_pc_corrected.Rdata"

## quarter PC
## RIN corrected data
#rin.corrected <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_rin_corrected.Rdata"

## exonic rate
#exonic.dat <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_exon.Rdata"

## expression profiling
#expeff.dat <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_expeff.Rdata"

## gc corrected
#gc.dat <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_gc.RData"

## multi3
#multi3.dat <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_multi3.Rdata"

## multicorr
#multicorr.dat <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_multicorr.Rdata"

## uncorrected data
#raw.data <- "/work-zfs/abattle4/parsana/networks_correction/data/raw_subset.Rdata"


## WGCNA
# TOMType = "unsigned" # instead take as input argument
minModuleSize = 10
reassignThreshold = 0
mergeCutHeight = 0.20
numericLabels = TRUE
pamRespectsDendro = FALSE
verbose = 3
maxBlockSize = 5000 # this is default in function
cutheights = seq(0.9,1.0,length.out = 50)

## graphical lasso
# range of penalty parameter
lambda = seq(0.3,1.0,length.out=50)
tol = 1e-04
maxIter = 1000
