source("../../src/config")
library(cowplot)

## Read files
theme_set(theme_cowplot(font_size=9)) # reduce default font size

plot.thyroid <- read.csv("pr_table_thyroid.csv", row.names = 1)
plot.thyroid <- plot.thyroid[-which(plot.thyroid$type %in% c("exonic rate","expeff", "gene GC%")),]
plot.thyroid$type <- factor(plot.thyroid$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.thyroid <- ggplot(plot.thyroid, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Thyroid")

plot.lung <- read.csv("pr_table_lung.csv", , row.names = 1)
plot.lung <- plot.lung[-which(plot.lung$type %in% c("exonic rate","expeff", "gene GC%")),]
plot.lung$type <- factor(plot.lung$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.lung <- ggplot(plot.lung, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Lung")

plot.sub <- read.csv("pr_table_sub.csv", row.names = 1)
plot.sub <- plot.sub[-which(plot.sub$type %in% c("exonic rate","expeff", "gene GC%")),]
plot.sub$type <- factor(plot.sub$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
plot.sub <- ggplot(plot.sub, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Adipose - Subcutaneous")

fig2 <- plot_grid(plot.sub + xlim(0,0.13) + ylim(0, 0.35) + theme(legend.position="none"),
	plot.thyroid + xlim(0,0.13) + ylim(0, 0.35) +  theme(legend.position="none"),
	plot.lung + xlim(0,0.13) + ylim(0, 0.35) + theme(legend.position="none"),
	align = 'vh',
           labels = c("a", "b", "c"),
           hjust = -1,
           nrow = 1
           )
legend <- get_legend(plot.lung +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1))))


fig2 <- plot_grid( fig2, legend, rel_widths = c(3, .4))

pdf("fig2.pdf", height = 2.5, width = 7.2)
print(fig2)
dev.off()
