library(reshape2)
library(ggplot2)
source("config")
#fn <- "Thyroid"
inputargs <- commandArgs(TRUE)
fn <- inputargs[1]
sn <- inputargs[2]
load("../networks/raw/wgcna_networks.RData")
sub.raw <- sapply(wgcna.networks[[fn]], function(x) length(which(x$colors == 0)))
load("../networks/rin//wgcna_networks.RData")
sub.rin <- sapply(wgcna.networks[[fn]], function(x) length(which(x$colors == 0)))
load("../networks/pc_corrected/wgcna_networks.RData")
sub.pc <- sapply(wgcna.networks[[fn]], function(x) length(which(x$colors == 0)))
load("../networks/half_pc_corrected/wgcna_networks.RData")
sub.halfpc <- sapply(wgcna.networks[[fn]], function(x) length(which(x$colors == 0)))
load("../networks/quarter_pc_corrected/wgcna_networks.RData")
sub.quarterpc <- sapply(wgcna.networks[[fn]], function(x) length(which(x$colors == 0)))

plot.dat <- as.data.frame(cbind(sub.raw,sub.rin,sub.quarterpc, sub.halfpc, sub.pc))
plot.dat
rownames(plot.dat) <- as.character(cutheights)
plot.dat <- melt(as.matrix(plot.dat))
ggplot(plot.dat, aes(x = Var1, y = value, colour = Var2)) + 
geom_point() + 
theme_classic() +
theme(text = element_text(size=20)) + xlab("Cut Height") + ylab("Number of genes in gray module") + ggtitle(fn)
ggsave(paste("../plots/",sn, "_wgcna_gray.png", sep = ""))
