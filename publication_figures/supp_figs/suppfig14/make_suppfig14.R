rm(list = ls())
library(cowplot)
theme_set(theme_cowplot(font_size=8)) # reduce default font size
# library(ggplot2)
load("/work-zfs/abattle4/parsana/networks_correction/results/enrichment/all_tissues.Rdata")



# Thyroid 
tiss <- "Thyroid"
pc_len = length(pc_enrichment_signed[[tiss]]$p.value)
raw_len = length(raw_enrichment_signed[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_signed[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_signed[[tiss]]$p.value)), sample_n)))
signed_plot_pval = data.frame(cbind(pc_pval, raw_pval))

pc_len = length(pc_enrichment_unsigned[[tiss]]$p.value)
raw_len = length(raw_enrichment_unsigned[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
unsigned_plot_pval = data.frame(cbind(pc_pval, raw_pval))

plot.thyroid <- ggplot()+
  geom_point(data = signed_plot_pval, aes(raw_pval, pc_pval, color = "signed"))+
  geom_point(data = unsigned_plot_pval, aes(raw_pval, pc_pval, color = "unsigned"))+labs(color="network type")+
  xlab("-log10(p-values) raw networks")+ ylab ("-log10(p-values) PC  networks")+
  geom_abline(color = "black") + ggtitle(tiss)



#Lung
tiss <- "Lung"
pc_len = length(pc_enrichment_signed[[tiss]]$p.value)
raw_len = length(raw_enrichment_signed[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_signed[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_signed[[tiss]]$p.value)), sample_n)))
signed_plot_pval = data.frame(cbind(pc_pval, raw_pval))

pc_len = length(pc_enrichment_unsigned[[tiss]]$p.value)
raw_len = length(raw_enrichment_unsigned[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
unsigned_plot_pval = data.frame(cbind(pc_pval, raw_pval))

plot.lung <- ggplot()+
  geom_point(data = signed_plot_pval, aes(raw_pval, pc_pval, color = "signed"))+
  geom_point(data = unsigned_plot_pval, aes(raw_pval, pc_pval, color = "unsigned"))+labs(color="network type")+
  xlab("-log10(p-values) raw networks")+ ylab ("-log10(p-values) PC  networks")+
  geom_abline(color = "black") + ggtitle(tiss)



# Subcutaneous 
tiss <- "Subcutaneous"
pc_len = length(pc_enrichment_signed[[tiss]]$p.value)
raw_len = length(raw_enrichment_signed[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_signed[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_signed[[tiss]]$p.value)), sample_n)))
signed_plot_pval = data.frame(cbind(pc_pval, raw_pval))

pc_len = length(pc_enrichment_unsigned[[tiss]]$p.value)
raw_len = length(raw_enrichment_unsigned[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
unsigned_plot_pval = data.frame(cbind(pc_pval, raw_pval))

plot.subcutaneous <- ggplot()+
  geom_point(data = signed_plot_pval, aes(raw_pval, pc_pval, color = "signed"))+
  geom_point(data = unsigned_plot_pval, aes(raw_pval, pc_pval, color = "unsigned"))+labs(color="network type")+
  xlab("-log10(p-values) raw networks")+ ylab ("-log10(p-values) PC  networks")+
  geom_abline(color = "black") + ggtitle(tiss)



# Muscle 
tiss <- "Muscle"
pc_len = length(pc_enrichment_signed[[tiss]]$p.value)
raw_len = length(raw_enrichment_signed[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_signed[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_signed[[tiss]]$p.value)), sample_n)))
signed_plot_pval = data.frame(cbind(pc_pval, raw_pval))

pc_len = length(pc_enrichment_unsigned[[tiss]]$p.value)
raw_len = length(raw_enrichment_unsigned[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
unsigned_plot_pval = data.frame(cbind(pc_pval, raw_pval))

plot.muscle <- ggplot()+
  geom_point(data = signed_plot_pval, aes(raw_pval, pc_pval, color = "signed"))+
  geom_point(data = unsigned_plot_pval, aes(raw_pval, pc_pval, color = "unsigned"))+labs(color="network type")+
  xlab("-log10(p-values) raw networks")+ ylab ("-log10(p-values) PC  networks")+
  geom_abline(color = "black") + ggtitle(tiss)



# Blood 
tiss <- "Blood"
pc_len = length(pc_enrichment_signed[[tiss]]$p.value)
raw_len = length(raw_enrichment_signed[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_signed[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_signed[[tiss]]$p.value)), sample_n)))
signed_plot_pval = data.frame(cbind(pc_pval, raw_pval))

pc_len = length(pc_enrichment_unsigned[[tiss]]$p.value)
raw_len = length(raw_enrichment_unsigned[[tiss]]$p.value)
sample_n = ifelse(pc_len < raw_len, pc_len, raw_len)
set.seed(10)
pc_pval <- sort(-log10(sample(as.numeric(unlist(pc_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
set.seed(10)
raw_pval <- sort(-log10(sample(as.numeric(unlist(raw_enrichment_unsigned[[tiss]]$p.value)), sample_n)))
unsigned_plot_pval = data.frame(cbind(pc_pval, raw_pval))

plot.blood <- ggplot()+
  geom_point(data = signed_plot_pval, aes(raw_pval, pc_pval, color = "signed"))+
  geom_point(data = unsigned_plot_pval, aes(raw_pval, pc_pval, color = "unsigned"))+labs(color="network type")+
  xlab("-log10(p-values) raw networks")+ ylab ("-log10(p-values) PC  networks")+
  geom_abline(color = "black") + ggtitle(tiss)




legend <- get_legend(plot.lung +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1))))

suppfig14 <- plot_grid(plot.subcutaneous +  theme(legend.position="none"),
	plot.thyroid + theme(legend.position="none"),
	plot.lung + theme(legend.position="none"),
	plot.muscle + theme(legend.position="none"),
	plot.blood + theme(legend.position="none"),
	legend,
#	align = 'vh',
           labels = c("a", "b", "c", "d", "e", ""),
           hjust = -1,
           nrow = 3
           )

pdf("suppfig14.pdf", height = 7.2, width = 7.2)
print(suppfig14)
dev.off()
