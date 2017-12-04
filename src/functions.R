###############
## Functions ##
###############
library(BiocParallel)

## Gene filtering ##
## thresholding by expression in at least n samples ##

select.genes <- function(rse.object, threshold, ...){
  counts <- SummarizedExperiment::assay(rse.object, 1)
  min.samples <- round(0.25*dim(rse.object)[2]) # default min.samples expression in at least 1/4 of samples
  keep <- apply(counts, 1, function(x, n = min.samples){
    t = sum(x >= threshold) >= n
    t
  })
  rse.object <- rse.object[keep,]
}


## PC correction - Residuals from Regressing Top PCs - modified to work for rse object ##
## Adopted from Claire's function ##

source("https://bioconductor.org/biocLite.R")
# biocLite("sva")
library(sva)

pc.estimate = function(rse.object, less.pc = F, alt.pc = F, ...){
  dat <- t(SummarizedExperiment::assay(rse.object, 1))
	
  ## determine number of principal components to adjust for
  mod = matrix(1, nrow = dim(dat)[1], ncol = 1)
  colnames(mod) = "Intercept"
	n.pc <- num.sv(t(dat), mod,method="be")
	n.pc
}

## pc correction
pc.correct <- function(rse.object, n.pc, less.pc = F, alt.pc = F, frac = NULL, rm.pc = NULL){
        dat <- t(SummarizedExperiment::assay(rse.object, 1))
	n.pc <- c(1:n.pc)
	if(less.pc){
                print(less.pc)
                n.pc <- c(1:round(max(n.pc) * frac))
        }
        if(alt.pc){
                n.pc <- n.pc[-rm.pc]
		print(n.pc)
        }
        ## singular value decomposition
        ss <- svd(scale(dat))
        print(paste("removing", n.pc, "PCs", nrow(dat)))
        ## use residuals from top n.pc principal components
#       for (i in 1:dim(dat)[2]){
        dat.adjusted <- lm(dat ~ ss$u[,n.pc])$residuals
#       }
        SummarizedExperiment::assay(rse.object, 1) <- t(dat.adjusted)
        rse.object
}
## Variable selection - per tissue
## select top n variable genes
variable.selection <- function(rse.object, n, ...){
  # method - currently variance based variable selection
  method = "variance"
  counts <- SummarizedExperiment::assay(rse.object, 1)
  if(method == "variance"){
    var.dat <- apply(counts, 1, var)
    rse.object <- rse.object[order(var.dat, decreasing = T)[1:n],]
  }
  rse.object
}

## Variable selection -- across tissues 
## select top n variable genes across all tissues in rse.object --> list
variable.selection.average <- function(rse.object, n, ...){
  # method - currently variance based variable selection
  method = "variance"
  counts <- lapply(rse.object, function(eachobject) SummarizedExperiment::assay(eachobject, 1))
  if(method == "variance"){
    var.dat <- lapply(counts, function(eachcount) apply(eachcount, 1, var))
    common.genes <- Reduce(intersect, lapply(var.dat,names))
    var.dat <- lapply(var.dat, function(x,y){
    	x[y]
    	},common.genes)
    select.vars <- names(sort(apply(do.call(cbind,
    	lapply(var.dat, function(x) rank(-x))), # get ranks (highest first by adding minus)
    1, mean)))[1:n]
    rse.object <- lapply(rse.object, function(eachobject,vars){
    	eachobject[vars,]
  }, select.vars)
    }
  rse.object
}

## RIN correction
covcorrect <- function(rse.object,covname){
	rin.vals <- colData(rse.object)[[covname]]
	expr.dat <- t(SummarizedExperiment::assay(rse.object, 1))
	rin.corrected <- lm(expr.dat~rin.vals)$residuals
	SummarizedExperiment::assay(rse.object, 1) <- t(rin.corrected)
	rse.object
	}

## Exonic rate correction
exoncorrect <- function(rse.object){
        exrt.vals <- colData(rse.object)$smexncrt
        expr.dat <- t(SummarizedExperiment::assay(rse.object, 1))
        exrt.corrected <- lm(expr.dat~exrt.vals)$residuals
        SummarizedExperiment::assay(rse.object, 1) <- t(exrt.corrected)
        rse.object
        }


## select power for WGCNA
pick.power = function(dat, nType = "unsigned"){
  pickSoftThreshold.output = pickSoftThreshold(dat, networkType = nType)
  #R2 = pickSoftThreshold.output$fitIndices$SFT.R.sq
  #power.list <- pickSoftThreshold.output$fitIndices$Power
  #power = ifelse( max(R2) >= 0.9, power.list[which(R2 >=  0.9)[1]], power.list[which(R2 == max(R2))[1]])
#  power = which(R2 == max(R2))
  power <- pickSoftThreshold.output$powerEstimate
  if(is.na(power)){
	print(paste("no power reached r-suared cut-off, now choosing max r-squared based power"))
	power <- pickSoftThreshold.output$fitIndices$Power[which(pickSoftThreshold.output$fitIndices$SFT.R.sq == max(pickSoftThreshold.output$fitIndices$SFT.R.sq))]
	}
  power
}

## normalize data before graphical lasso
normalize <- function(rse.object){
  dat <- t(SummarizedExperiment::assay(rse.object,1))
  n = nrow(dat)
  p = ncol(dat)
  rank.dat =  dat # matrix for ranking
  for (i in 1:p){
    rank.dat[,i] = rank(dat[,i])
  }
  U = rank.dat/(n+1)
  norm.dat = qnorm(U)
  SummarizedExperiment::assay(rse.object, 1) <- t(norm.dat)
  rse.object
}

## learn gaussian markov random field with graphical lasso
  # Input - rse object
  # transpose counts(rse.object) so that
  # columns --> genes
  # rows --> samples
  # QUIC
graph.lasso <- function(rse.object, rho.values, tolerance, max.iter){
  rse.object <- normalize(rse.object)
  norm.dat <- SummarizedExperiment::assay(rse.object, 1)
  cov.mat <- cov(t(norm.dat)) # genes --> columns and samples --> rows
  precision.mat <- mclapply(rho.values, function(x, cov.matrix, tolerance, max.iter){
    print(x)
    library(QUIC)
    p.mat <- QUIC(cov.mat, rho = x, tol = tolerance, maxIter = max.iter)$X
    p.mat[lower.tri(p.mat)] <- NA
    p.mat[p.mat == 0.0] <- NA
    diag(p.mat) <- NA
    p.mat
    }
    , cov.mat, tolerance, maxIter, mc.preschedule = F, mc.cores = 5)
  precision.mat
}


## WGCNA networks at different cut height
weighted.networks <- function(dat, cutheights, power, blocks = NULL, goodGenes = NULL, goodSamples = NULL, dendrograms = NULL, networkType = "unsigned"){
	source("config")
#	if(is.null(networkType)){
#		networkType <- "unsigned"
#	}
	if(networkType != "unsigned"){
		TOMType <- networkType
	}
	if(cutheights == 0.9){
		w.networks <- blockwiseModules(dat, power = power,TOMType = TOMType, saveTOMs = TRUE,
                                minModuleSize = minModuleSize, networkType = networkType,
                                reassignThreshold = reassignThreshold, detectCutHeight = cutheights, mergeCutHeight = mergeCutHeight,
                                numericLabels = numericLabels, pamRespectsDendro = pamRespectsDendro,verbose = verbose, maxBlockSize = maxBlockSize)
	}else{
		w.networks <- lapply(cutheights, function(x,y,a,b,c,d,e){
					print(x)
					recutBlockwiseTrees(y, blocks = a, TOMFiles = "blockwiseTOM-block.1.RData", minModuleSize = minModuleSize, goodGenes = b, goodSamples = c, networkType = e,
                                reassignThreshold = reassignThreshold, detectCutHeight = x, mergeCutHeight = mergeCutHeight, dendrograms = d,
                                numericLabels = numericLabels, pamRespectsDendro = pamRespectsDendro,verbose = verbose)
			}, dat, blocks, goodGenes, goodSamples, dendrograms, networkType)
	}
	w.networks
}
