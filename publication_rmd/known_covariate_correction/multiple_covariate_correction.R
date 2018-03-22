# load libraries
library(dplyr)
library(recount)

# load data
load("/work-zfs/abattle4/parsana/networks_correction/data/raw_subset.Rdata")
load("/work-zfs/abattle4/parsana/networks_correction/publication_rmd/known_covariate_correction/tissue_pve.RData")

# variables to be used for multiple correction in each tissue
sub.var <- pve.plot %>% filter(.id == "Subcutaneous") %>% 
filter(!variable %in% tss.rss$Subcutaneous$remove) %>% 
filter(value >= 0.01) %>% select(variable)

lung.var <- pve.plot %>% filter(.id == "Lung") %>% 
filter(!variable %in% tss.rss$Lung$remove) %>% 
filter(value >= 0.01) %>% select(variable)

muscle.var <- pve.plot %>% filter(.id == "Muscle") %>% 
filter(!variable %in% tss.rss$Muscle$remove) %>% 
filter(value >= 0.01) %>% select(variable)

thyroid.var <- pve.plot %>% filter(.id == "Thyroid") %>% 
filter(!variable %in% tss.rss$Thyroid$remove) %>% 
filter(value >= 0.01) %>% select(variable)

blood.var <- pve.plot %>% filter(.id == "Blood") %>% 
filter(!variable %in% tss.rss$Blood$remove) %>% 
filter(value >= 0.01) %>% select(variable)

var.regress <- list(Subcutaneous = sub.var, Lung = lung.var, Thyroid = thyroid.var, Muscle = muscle.var, Blood = blood.var)

# regressed data

multi.corrected <- mapply(function(x,y){
	cov <- x@colData
	cov <- cov[,which(colnames(cov) %in% y$variable)]
	exp.dat <- SummarizedExperiment::assay(x, 1)
	dat.corrected <- lm(t(exp.dat)~., data = cov)$residual
	SummarizedExperiment::assay(x, 1) <- t(dat.corrected)
	x
	}, gtex.rse.sub, var.regress)

save(multi.corrected, file = "/work-zfs/abattle4/parsana/networks_correction/data/multiple_covariate_corrected.RData")
