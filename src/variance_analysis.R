rm(list=ls())

setwd("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/")

## get libraries and functions
library("recount")
source("src/functions.R")

## load data
load("data/gtex_rse.Rdata")

n <- 5000
 
counts <- lapply(gtex.rse, function(eachobject) SummarizedExperiment::assay(eachobject, 1))
var.dat.pertiss <- lapply(counts, function(eachcount) apply(eachcount, 1, var))
common.genes <- Reduce(intersect, lapply(var.dat.pertiss,names))
var.dat <- lapply(var.dat.pertiss, function(x,y){
	x[y]
	},common.genes)
select.vars <- names(sort(apply(do.call(cbind,
	lapply(var.dat, function(x) rank(-x))), # get ranks (highest first by adding minus)
1, mean)))[1:n]

select.pertiss.vars <- lapply(var.dat.pertiss, function(x){
	sel <- sort(rank(-x))[1:5000]
	x[names(sel)]
	})

select.common.vars <- lapply(var.dat.pertiss, function(x,y){
	x[y]
	}, select.vars)

low.variance.gene.names <- lapply(select.common.vars, function(x) which(x < 0.6))

mapply(function(x,y){ length(intersect(which(x[[49]]$colors == 0),y))/length(y)},wgcna.networks,low.variance.gene.names)
