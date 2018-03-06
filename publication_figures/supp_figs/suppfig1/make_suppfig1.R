source("/work-zfs/abattle4/parsana/networks_correction/src/config")
library(cowplot)

## Read files
theme_set(theme_cowplot(font_size=12)) # reduce default font size

wgcna.plot.muscle <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/pr_table_muscle.csv", 
	row.names = 1, stringsAsFactors = F)
wgcna.plot.muscle <- wgcna.plot.muscle[-which(wgcna.plot.muscle$type %in% c("exonic rate","expeff", "gene GC%")),]
wgcna.plot.muscle$type <- factor(wgcna.plot.muscle$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
wgcna.plot.muscle <- ggplot(wgcna.plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Muscle - Skeletal")

wgcna.plot.blood <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/pr_table_blood.csv", 
	row.names = 1, stringsAsFactors = F)
wgcna.plot.blood <- wgcna.plot.blood[-which(wgcna.plot.blood$type %in% c("exonic rate", "expeff", "gene GC%")),]
wgcna.plot.blood$type <- factor(wgcna.plot.blood$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
wgcna.plot.blood <- ggplot(wgcna.plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Whole Blood")

glasso.plot.muscle <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig3/pr_table_muscle.csv", 
	row.names = 1, stringsAsFactors = F)
glasso.plot.muscle <- glasso.plot.muscle[-which(glasso.plot.muscle$type %in% c("exonic rate","expeff", "gene GC%")),]
glasso.plot.muscle$type <- factor(glasso.plot.muscle$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
glasso.plot.muscle <- ggplot(glasso.plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
	xlab("Recall") + ylab("Precision")+ggtitle("Muscle-Skeletal")

glasso.plot.blood <- read.csv("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig3/pr_table_blood.csv", 
	row.names = 1, stringsAsFactors = F)
glasso.plot.blood <- glasso.plot.blood[-which(glasso.plot.blood$type %in% c("exonic rate", "expeff", "gene GC%")),]
glasso.plot.blood$type <- factor(glasso.plot.blood$type, levels = c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected"))
glasso.plot.blood <- ggplot(glasso.plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3)+
		     xlab("Recall") + ylab("Precision")+ggtitle("Whole Blood") 

supp.fig.p1 <- plot_grid(wgcna.plot.blood + xlim(0,0.16) + ylim(0, 0.35) + theme(legend.position="none"),
	wgcna.plot.muscle + xlim(0,0.16) + ylim(0, 0.35) +  theme(legend.position="none"),
	align = 'vh',
           labels = c("a", "b"),
           hjust = -1,
           nrow = 1
           )
wgcna.legend <- get_legend(wgcna.plot.blood +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1))))

supp.fig.p1 <- plot_grid( supp.fig.p1, wgcna.legend, rel_widths = c(3, .4))

supp.fig.p2 <- plot_grid(glasso.plot.blood + xlim(0,0.013) + ylim(0, 0.75) + theme(legend.position="none"),
	glasso.plot.muscle + xlim(0,0.013) + ylim(0, 0.75) +  theme(legend.position="none"),
	align = 'vh',
           labels = c("c", "d"),
           hjust = -1,
           nrow = 1
           )
glasso.legend <- get_legend(glasso.plot.muscle +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1))))


supp.fig.p2 <- plot_grid( supp.fig.p2, glasso.legend, rel_widths = c(3, .4))

merged.supp.fig <- plot_grid(supp.fig.p1, supp.fig.p2, nrow = 2)
pdf("supp_fig1.pdf", height = 7.2, width = 7.2)
print(merged.supp.fig)
dev.off()
