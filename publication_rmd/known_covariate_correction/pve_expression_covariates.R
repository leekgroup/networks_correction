## load library
library(caret)
library(knitr)

library(ggplot2)
library(reshape2)
library(broom)
library(Hmisc)
library(corrplot)
library(dplyr)
load("/work-zfs/abattle4/parsana/networks_correction/data/gtex_rse.Rdata")

compute.rss <- function(tiss){
	cov <- tiss@colData[,c(21:80)]
	rm.cov <- c("smpthnts", "smnabtch", "smnabtchd", "smgebtch")
	cov <- cov[,!names(cov) %in% rm.cov]
	cov <- cov[,-which(sapply(cov, function(x) length(unique(x))) == 1)]
	exp <- tiss@assays$data$counts
	cov.corr <- rcorr(as.matrix(cov[,which(sapply(cov, class) %in% c("integer", "numeric"))]), type = "spearman")$r
	rm.variables <- findCorrelation(cov.corr, cutoff = 0.75, names = T)
	# cov <- cov[,-which(colnames(cov) %in% rm.variables)]
	lm.out <- lapply(cov, function(x) lm(t(exp) ~ x))
	tss <- (norm((exp - rowMeans(exp)), type = "F"))^2
	rss <- sapply(lm.out, function(x) (norm(x$residual, type = "F"))^2)
	dof <- sapply(lm.out, function(x) x$df.residual)
	n <- ncol(tiss@assays$data$counts)
	list(tss = tss, rss = rss, n = n, dof = dof, cov_corr = cov.corr, remove = rm.variables)
}

compute.pve <- function(tiss){
	R.2 <- (tiss$tss - tiss$rss)/tiss$tss
	adj.R.2 - ((1-R.2) * ((tiss$n - 1) / tiss$dof))
	adj.R.2
	# ((tiss$tss - tiss$rss)/tiss$tss)
}

# total sum of colors for each tissue

tss.rss <- lapply(gtex.rse, compute.rss)

tiss.pve <- lapply(tss.rss, compute.pve)

tiss.pve <- plyr::ldply(tiss.pve , rbind)

pve.plot <- melt(tiss.pve)

library(RColorBrewer)
myPalette <- colorRampPalette(brewer.pal(9,'Blues'), space = "Lab")
ggplot(pve.plot, aes(.id, variable)) + geom_tile(aes(fill = value),
	     colour = "white") + 
		geom_text(size = 2, aes(label = prettyNum(value, digits=3, width=4, format="fg")
)) +
		scale_fill_gradientn(colours = myPalette(10)[1:6]
			, limits = c(0,0.20)
			) + 
		xlab("Covariates") + ylab("Expression PC") + theme(axis.text.x=element_text(colour="black", angle = 90, hjust = 1), 
			axis.text.y=element_text(colour="black"))
	ggsave("pve.png")


png("Lung.png", res = 450, height = 7, width = 7, units = "in")
corrplot(tss.rss$Lung$cov_corr, type="upper", method = "square", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
dev.off()

png("Sub.png", res = 450, height = 7, width = 7, units = "in")
corrplot(tss.rss$Subcutaneous$cov_corr, type="upper", method = "square", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
dev.off()

png("Thyroid.png", res = 450, height = 7, width = 7, units = "in")
corrplot(tss.rss$Thyroid$cov_corr, type="upper", method = "square", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
dev.off()

png("Blood.png", res = 450, height = 7, width = 7, units = "in")
corrplot(tss.rss$Blood$cov_corr, type="upper", method = "square", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
dev.off()

png("Muscle.png", res = 450, height = 7, width = 7, units = "in")
corrplot(tss.rss$Muscle$cov_corr, type="upper", method = "square", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
dev.off()

print(paste("Top covariates for Adipose: "))
pve.plot %>% filter(.id == "Subcutaneous") %>% 
filter(!variable %in% tss.rss$Subcutaneous$remove) %>% 
filter(value >= 0.01)

print(paste("Top covariates for Lung: "))

pve.plot %>% filter(.id == "Lung") %>% 
filter(!variable %in% tss.rss$Lung$remove) %>% 
filter(value >= 0.01)

print(paste("Top covariates for Muscle: "))

pve.plot %>% filter(.id == "Muscle") %>% 
filter(!variable %in% tss.rss$Muscle$remove) %>% 
filter(value >= 0.01)
print(paste("Top covariates for Thyroid: "))

pve.plot %>% filter(.id == "Thyroid") %>% 
filter(!variable %in% tss.rss$Thyroid$remove) %>% 
filter(value >= 0.01)

print(paste("Top covariates for Whole Blood: "))

pve.plot %>% filter(.id == "Blood") %>% 
filter(!variable %in% tss.rss$Blood$remove) %>% 
filter(value >= 0.01)

## write files
write.csv(tiss.pve, file = "known_covariates_expression_pve.csv")
write.csv(tss.rss$Lung$cov_corr, file = "Lung.csv")
write.csv(tss.rss$Subcutaneous$cov_corr, file = "Subcutaneous.csv")
write.csv(tss.rss$Blood$cov_corr, file = "Blood.csv")
write.csv(tss.rss$Muscle$cov_corr, file = "Muscle.csv")
write.csv(tss.rss$Thyroid$cov_corr, file = "Thyroid.csv")

## Save output
save(pve.plot, tss.rss, file = "tissue_pve.RData")


