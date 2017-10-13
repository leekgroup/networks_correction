source("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/src/config")
library(cowplot)

## Read files
theme_set(theme_cowplot(font_size=9)) # reduce default font size

plot.thyroid <- read.csv("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig3/pr_table_thyroid.csv", row.names = 1, stringsAsFactors = F)
plot.thyroid <- plot.thyroid[-which(plot.thyroid$type %in% c("gene GC%","expeff", "exonic rate")),]
plot.thyroid$type <- factor(plot.thyroid$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.thyroid <- ggplot(plot.thyroid, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Thyroid")


plot.muscle <- read.csv("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig3/pr_table_muscle.csv", row.names = 1, stringsAsFactors = F)
plot.muscle <- plot.muscle[-which(plot.muscle$type %in% c("gene GC%","expeff", "exonic rate")),]
plot.muscle$type <- factor(plot.muscle$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.muscle <- ggplot(plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Muscle - Skeletal")

plot.lung <- read.csv("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig3/pr_table_lung.csv", , row.names = 1, stringsAsFactors = F)
plot.lung <- plot.lung[-which(plot.lung$type %in% c("gene GC%","expeff", "exonic rate")),]
plot.lung$type <- factor(plot.lung$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.lung <- ggplot(plot.lung, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Lung")

plot.blood <- read.csv("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig3/pr_table_blood.csv", , row.names = 1, stringsAsFactors = F)
plot.blood <- plot.blood[-which(plot.blood$type %in% c("gene GC%","expeff", "exonic rate")),]
plot.blood$type <- factor(plot.blood$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.blood <- ggplot(plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Whole Blood")

plot.sub <- read.csv("/home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig3/pr_table_sub.csv", row.names = 1, stringsAsFactors = F)
plot.sub <- plot.sub[-which(plot.sub$type %in% c("gene GC%","expeff", "exonic rate")),]
plot.sub$type <- factor(plot.sub$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.sub <- ggplot(plot.sub, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Adipose - Subcutaneous")

	
fig3 <- plot_grid(plot.sub + xlim(0,0.015) + ylim(0, 0.71) + theme(legend.position="none"),
	plot.thyroid + xlim(0,0.015) + ylim(0, 0.71) +  theme(legend.position="none"),
	plot.lung + xlim(0,0.015) + ylim(0, 0.71) + theme(legend.position="none"),
	align = 'vh',
           labels = c("a", "b", "c"),
           hjust = -1,
           nrow = 1
           )
legend <- get_legend(plot.lung +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1))))


fig3 <- plot_grid( fig3, legend, rel_widths = c(3, .4))

pdf("fig3.pdf", height = 2.5, width = 7.2)
print(fig3)
dev.off()
# save_plot("fig2.pdf", fig2,
#           ncol = 3, # we're saving a grid plot of 2 columns
#           nrow = 1, # and 2 rows
#           # each individual subplot should have an aspect ratio of 1.3
#           base_height = 2.4, base_width = 2.4,
#           )
