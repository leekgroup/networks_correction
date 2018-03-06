### Load libraries
library(parallel)
library(recount)
library(ggplot2)
library(RColorBrewer)
library(reshape2)
library(cowplot)
# Load/Read data
raw.data <- "/work-zfs/abattle4/parsana/networks_correction/data/gtex_rse.Rdata"
load(raw.data)
gene_gc <- read.delim("gene_full_gc_content.txt", header = F, stringsAsFactors = F)

## functions:
getpc <- function(rse.object, n.pc){
        dat <- t(SummarizedExperiment::assay(rse.object, 1))
		n.pc <- c(1:n.pc)
        ## singular value decomposition
        ss <- svd(scale(dat))
        loadings <- ss$u[,n.pc]
		loadings
}

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

gc.coeff <- lapply(gc.fit, function(each.gc.fit){
 	each.gc.fit$coefficients[2,]
 	})

save(gc.coeff, file = "gc_estimate_sample.RData")
# total.samples <- lapply(gtex.rse, function(p) dim(p)[2])
# significant.pvals <- lapply(pvals, function(p){
# 	length(which(p<0.05))/length(p)
# 	})


pc.tissue <- c(37, 30, 38, 39, 25) # number of pcs removed in each tissue
names(pc.tissue) <- names(gtex.rse)
gtex.rse.pcs <- mcmapply(getpc, gtex.rse, pc.tissue) # compute PCs and get loadings

save(gtex.rse.pcs, file = "pcs_removed.RData") # save the loadings as RData object

#### test association of expression PCs with gc coefficients
	# fit linear model
	gc.pc <- mapply(function(p,q){
		lm.gc.fit <- lm(p ~ q)
		lm.gc.fit
		}, gtex.rse.pcs, gc.coeff, SIMPLIFY = FALSE
		)
	# extract p-values
	gc.pc.pvals <- lapply(gc.pc, function(lm.gc.fit){
		pval <- sapply(summary(lm.gc.fit), function(x) x$coefficients[2,4])
		pval <- p.adjust(pval, method = "BH")
		pval
		})
	# extract percent variance explained/ R2
	r2.pcs <- lapply(gc.pc, function(lm.gc.fit){
		pval <- sapply(summary(lm.gc.fit), function(x) x$r.squared)
		pval
		})

	# merge the lists to a matrix
	r2.pcs <- sapply(r2.pcs, function(x) {length(x) <- 39; x})
	gc.pc.pvals <- sapply(gc.pc.pvals, function(x) {length(x) <- 39; x})
	rownames(r2.pcs) <- paste("PC",1:39,sep="")
	rownames(gc.pc.pvals) <- paste("PC",1:39,sep="")

# prepare data for plotting with ggplot2
plot.r2 <- melt(r2.pcs)
plot.pvals <- melt(gc.pc.pvals)

	# set color pallete
	# myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")), space="Lab")
	myPalette <- colorRampPalette(brewer.pal(9,'Blues'), space = "Lab")

	# set default font size
	theme_set(theme_classic(base_size = 9)) 
	
	# plot p-values
	pval.fig <- ggplot(plot.pvals, aes(Var2, Var1)) + geom_tile(aes(fill = value),
	     colour = "white") + 
		geom_text(size = 2, aes(label = prettyNum(value, digits=3, width=4, format="fg")
)) +
		scale_fill_gradientn(colours = rev(myPalette(10)[1:6]), limits = c(0,1)
, values = c(0, 0.005, 0.05, 0.1, 0.5, 1)
) + xlab("") + ylab("Principal Components") + theme(axis.text.x=element_text(colour="black"), axis.text.y=element_text(colour="black"))
	ggsave("pvals.png")

	# plot r2
	r2.fig <- ggplot(plot.r2, aes(Var2, Var1)) + geom_tile(aes(fill = value),
	     colour = "white") + 
		geom_text(size = 2, aes(label = prettyNum(value, digits=3, width=4, format="fg")
)) +
		scale_fill_gradientn(colours = myPalette(10)[1:6], limits = c(0,1)
		, values = c(0, 0.05, 0.1, 0.2, 0.3, 0.4, 1)
) + xlab("") + ylab("Principal Components") + theme(axis.text.x=element_text(colour="black"), axis.text.y=element_text(colour="black"))
	ggsave("r2.png")

fig2 <- plot_grid(pval.fig + theme(legend.position="bottom", legend.direction = "horizontal"),
	r2.fig + theme(legend.position="bottom", legend.direction="horizontal"),
	align = 'vh',
           labels = c("a", "b"),
           hjust = -1,
           nrow = 1
           )

pdf("supp_fig_gc_heatmap.pdf", height = 8.5, width = 7)
print(fig2)
dev.off()
