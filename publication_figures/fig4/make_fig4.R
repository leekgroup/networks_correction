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

add_densityx <- function(pr_table, x_axis){
  rep.num <- nrow(pr_table)/length(x_axis)
  pr_table$xaxis <- rep(x_axis, rep.num)
  pr_table
}

plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- add_densityx(plot.thyroid, cutheights)
plot.thyroid <- ggplot(plot.thyroid, aes(x = xaxis, y = density, colour = type)) + geom_point(size = 0.3) + 
  xlab("Cutheights") + ylab("# of edges")+ggtitle("Thyroid")

plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- add_densityx(plot.lung, cutheights)
plot.lung <- ggplot(plot.lung, aes(x = xaxis, y = density, colour = type)) + geom_point(size = 0.3) + 
  xlab("Cutheights") + ylab("# of edges")+ggtitle("Lung")

plot.subcutaneous <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna_canonical_subcutaneous.Rds")
plot.subcutaneous <- select_category(cat.plot, plot.subcutaneous)
plot.subcutaneous <- add_densityx(plot.subcutaneous, cutheights)
plot.subcutaneous <- ggplot(plot.subcutaneous, aes(x = xaxis, y = density, colour = type)) + geom_point(size = 0.3) + 
  xlab("Cutheights") + ylab("# of edges")+ggtitle("Adipose - Subcutaneous")


fig4.wgcna <- plot_grid(plot.subcutaneous + xlim(1.0,0.9) + theme(legend.position="none"),
  plot.thyroid + xlim(1.0,0.9) +  theme(legend.position="none"),
  plot.lung + xlim(1.0,0.9) + theme(legend.position="none"),
  align = 'vh',
           labels = c("a", "b", "c"),
           hjust = -1,
           nrow = 1
           )
legend.wgcna <- get_legend(plot.lung +
  theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
  legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1,"line")) + 
  guides(colour = guide_legend(override.aes = list(size= 1)), fill=guide_legend("type")))

fig4.a <- plot_grid( fig4.wgcna, legend.wgcna, rel_widths = c(3, .4))

## Glasso

plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_networks_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- add_densityx(plot.thyroid, lambda)
plot.thyroid <- ggplot(plot.thyroid, aes(x = xaxis, y = density, colour = type)) + geom_point(size = 0.3) + 
  xlab("Penalty") + ylab("# of edges")+ggtitle("Thyroid")

plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_networks_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- add_densityx(plot.lung, lambda)
plot.lung <- ggplot(plot.lung, aes(x = xaxis, y = density, colour = type)) + geom_point(size = 0.3) + 
  xlab("Penalty") + ylab("# of edges")+ggtitle("Lung")

plot.subcutaneous <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_networks_canonical_subcutaneous.Rds")
plot.subcutaneous <- select_category(cat.plot, plot.subcutaneous)
plot.subcutaneous <- add_densityx(plot.subcutaneous, lambda)
plot.subcutaneous <- ggplot(plot.subcutaneous, aes(x = xaxis, y = density, colour = type)) + geom_point(size = 0.3) + 
  xlab("Penalty") + ylab("# of edges")+ggtitle("Adipose - Subcutaneous")


fig4.glasso <- plot_grid(plot.subcutaneous + xlim(0.3,1.0) + theme(legend.position="none"),
  plot.thyroid + xlim(0.3,1.0) +  theme(legend.position="none"),
  plot.lung + xlim(0.3,1.0) + theme(legend.position="none"),
  align = 'vh',
           labels = c("a", "b", "c"),
           hjust = -1,
           nrow = 1
           )
legend.glasso <- get_legend(plot.lung +
  theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
  legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1,"line")) + 
  guides(colour = guide_legend(override.aes = list(size= 1)), fill=guide_legend("type")))

fig4.b <- plot_grid( fig4.glasso, legend.glasso, rel_widths = c(3, .4))

fig4 <- plot_grid(fig4.a, fig4.b, nrow = 2)

pdf("fig4.pdf", height = 4.5, width = 7.2)
print(fig4)
dev.off()

