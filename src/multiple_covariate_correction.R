# load libraries
library(dplyr)
library(recount)

# load data
inputargs <- commandArgs(TRUE)
exp.fn <- inputargs[1]
# exp.fn <- "/work-zfs/abattle4/parsana/networks_correction/data/raw_subset.Rdata"
tiss.pve.fn <- inputargs[2]
# tiss.pve.fn <- "/work-zfs/abattle4/parsana/networks_correction/results/tissue_pve.Rds"
load(exp.fn)
tiss.pve.list <- readRDS(tiss.pve.fn)
save.fn <- inputargs[3]
# save.fn <- "/work-zfs/abattle4/parsana/networks_correction/data/mc_corrected.Rdata"
pve.plot <- tiss.pve.list$pve_plot
tss.rss <- tiss.pve.list$tss_rss
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

artery.var <- pve.plot %>% filter(.id == "Artery_tibial") %>%
filter(!variable %in% tss.rss$Artery_Tibial$remove) %>%
filter(value >= 0.01)

nerve.var <- pve.plot %>% filter(.id == "Nerve_tibial") %>%
filter(!variable %in% tss.rss$Nerve_Tibial$remove) %>%
filter(value >= 0.01)

skin.var <- pve.plot %>% filter(.id == "Skin") %>%
filter(!variable %in% tss.rss$Skin$remove) %>%
filter(value >= 0.01)

var.regress <- list(Subcutaneous = sub.var, Lung = lung.var, Thyroid = thyroid.var, Muscle = muscle.var, Blood = blood.var, Artery_tibial = artery.var,
		Nerve_tibial = nerve.var, Skin = skin.var)

# regressed data

gtex.rse.multicorr <- mapply(function(x,y){
	cov <- x@colData
	cov <- cov[,which(colnames(cov) %in% y$variable)]
	exp.dat <- SummarizedExperiment::assay(x, 1)
	dat.corrected <- lm(t(exp.dat)~., data = cov)$residual
	SummarizedExperiment::assay(x, 1) <- t(dat.corrected)
	x
	}, dat.expr, var.regress)

dat.expr <- gtex.rse.multicorr

save(dat.expr, file = save.fn)
