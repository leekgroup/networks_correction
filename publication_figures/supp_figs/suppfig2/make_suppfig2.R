source("/work-zfs/abattle4/parsana/networks_correction/src/config.R")
library(cowplot)

## Read files
theme_set(theme_cowplot(font_size=9)) # reduce default font size

## categories to plot
cat.plot <- c("PC", "half-PC", "quarter-PC", "exonic rate", "uncorrected")

# select category to plot
select_category <- function(category_name, pr_table){
	pr_table <- pr_table[which(pr_table$type %in% category_name),]
}


plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- ggplot(plot.thyroid, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Thyroid")

plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- ggplot(plot.lung, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Lung")

plot.subcutaneous <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_subcutaneous.Rds")
plot.subcutaneous <- select_category(cat.plot, plot.subcutaneous)
plot.subcutaneous <- ggplot(plot.subcutaneous, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Subcutaneous")

plot.muscle <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_muscle.Rds")
plot.muscle <- select_category(cat.plot, plot.muscle)
plot.muscle <- ggplot(plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Muscle")

plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Blood")

legend <- get_legend(plot.lung +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1))))

supp_fig2 <- plot_grid(plot.subcutaneous + xlim(0,0.16) + ylim(0, 0.35) + theme(legend.position="none"),
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

