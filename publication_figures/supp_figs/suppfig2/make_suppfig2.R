source("/work-zfs/abattle4/parsana/networks_correction/src/config")
library(cowplot)

## Read files
theme_set(theme_cowplot(font_size=12)) # reduce default font size

plot.thyroid <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/pr_table_thyroid.csv", row.names = 1, stringsAsFactors = F)
plot.thyroid <- plot.thyroid[-which(plot.thyroid$type %in% c("RIN","expeff", "gene GC%")),]
plot.thyroid$type <- factor(plot.thyroid$type, levels = c("PC corrected","half-PC","quarter-PC", "exonic rate", "uncorrected"))
plot.thyroid <- ggplot(plot.thyroid, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Thyroid")


plot.muscle <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/pr_table_muscle.csv", row.names = 1, stringsAsFactors = F)
plot.muscle <- plot.muscle[-which(plot.muscle$type %in% c("RIN","expeff", "gene GC%")),]
plot.muscle$type <- factor(plot.muscle$type, levels = c("PC corrected","half-PC","quarter-PC", "exonic rate", "uncorrected"))
plot.muscle <- ggplot(plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Muscle - Skeletal")

plot.lung <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/pr_table_lung.csv", , row.names = 1, stringsAsFactors = F)
plot.lung <- plot.lung[-which(plot.lung$type %in% c("RIN","expeff", "gene GC%")),]
plot.lung$type <- factor(plot.lung$type, levels = c("PC corrected","half-PC","quarter-PC", "exonic rate", "uncorrected"))
plot.lung <- ggplot(plot.lung, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Lung")

plot.blood <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/pr_table_blood.csv", , row.names = 1, stringsAsFactors = F)
plot.blood <- plot.blood[-which(plot.blood$type %in% c("RIN","expeff", "gene GC%")),]
plot.blood$type <- factor(plot.blood$type, levels = c("PC corrected","half-PC","quarter-PC", "exonic rate", "uncorrected"))
plot.blood <- ggplot(plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Whole Blood")

plot.sub <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/pr_table_sub.csv", row.names = 1, stringsAsFactors = F)
plot.sub <- plot.sub[-which(plot.sub$type %in% c("RIN","expeff", "gene GC%")),]
plot.sub$type <- factor(plot.sub$type, levels = c("PC corrected","half-PC","quarter-PC", "exonic rate", "uncorrected"))
plot.sub <- ggplot(plot.sub, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Adipose - Subcutaneous")

legend <- get_legend(plot.lung +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1))))

supp_fig2 <- plot_grid(plot.sub + xlim(0,0.16) + ylim(0, 0.35) + theme(legend.position="none"),
	plot.thyroid + xlim(0,0.16) + ylim(0, 0.35) +  theme(legend.position="none"),
	plot.lung + xlim(0,0.16) + ylim(0, 0.35) + theme(legend.position="none"),
	plot.muscle + xlim(0,0.16) + ylim(0, 0.35) + theme(legend.position="none"),
	plot.blood + xlim(0,0.16) + ylim(0, 0.35) + theme(legend.position="none"),
	legend,
#	align = 'vh',
           labels = c("a", "b", "c", "d", "e", ""),
           hjust = -1,
           nrow = 3
           )


#supp_fig2 <- plot_grid( supp_fig2, legend, rel_widths = c(3, .4))

pdf("supp_fig2.pdf", height = 7.2, width = 7.2)
print(supp_fig2)
dev.off()
