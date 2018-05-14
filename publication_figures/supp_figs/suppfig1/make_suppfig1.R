source("/work-zfs/abattle4/parsana/networks_correction/src/config.R")
library(cowplot)

theme_set(theme_cowplot(font_size=9)) # reduce default font size
## categories to plot
cat.plot <- c("PC", "half-PC", "quarter-PC", "RIN", "uncorrected")

# select category to plot
select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$type %in% category_name),]
  pr_table
}



plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Whole Blood")

plot.muscle <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_muscle.Rds")
plot.muscle <- select_category(cat.plot, plot.muscle)
plot.muscle <- ggplot(plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Skeletal Muscle")

suppfig1.wgcna <- plot_grid(plot.blood + xlim(0,0.07) + ylim(0, 0.5) +  theme(legend.position="none"),
  plot.muscle + xlim(0,0.07) + ylim(0, 0.5) + theme(legend.position="none"),
  align = 'vh',
           labels = c("a", "b", "c"),
           hjust = -1,
           nrow = 1
           )

legend.wgcna <- get_legend(plot.blood +
  theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
  legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
  guides(colour = guide_legend(override.aes = list(size= 1))))


suppfig1.a <- plot_grid( suppfig1.wgcna, legend.wgcna, rel_widths = c(3, .4))

## Glasso

plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_networks_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Whole Blood")

plot.muscle <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_networks_canonical_muscle.Rds")
plot.muscle <- select_category(cat.plot, plot.muscle)
plot.muscle <- ggplot(plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  xlab("Recall") + ylab("Precision")+ggtitle("Skeletal Muscle")

suppfig1.glasso <- plot_grid(plot.blood + xlim(0, 0.02) + ylim(0, 0.9) +  theme(legend.position="none"),
  plot.muscle + xlim(0, 0.02) + ylim(0, 0.9) + theme(legend.position="none"),
  align = 'vh',
           labels = c("a", "b", "c"),
           hjust = -1,
           nrow = 1
           )

legend.glasso <- get_legend(plot.blood +
  theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
  legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
  guides(colour = guide_legend(override.aes = list(size= 1))))

suppfig1.b <- plot_grid( suppfig1.glasso, legend.glasso, rel_widths = c(3, .4))

suppfig1 <- plot_grid(suppfig1.a, suppfig1.b, nrow = 2)

pdf("suppfig1.pdf", height = 7.2, width = 7.2)
print(suppfig1)
dev.off()

