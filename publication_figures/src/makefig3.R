# source("/work-zfs/abattle4/parsana/networks_correction/src/config.R")
library(cowplot)

theme_set(theme_cowplot(font_size=9)) # reduce default font size
## categories to plot
#cat.plot <- c("uncorrected", "RIN", "PC")

# select category to plot
cutheights <- seq(0.9,1.0, length.out = 50)
lambda <- seq(0.3,1.0, length.out = 50)

cat.plot <- c("uncorrected", "RIN", "multi-covariate", "PC")
# select category to plot
select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$type %in% category_name),]
  pr_table$type <- factor(pr_table$type, levels = category_name)
  pr_table$cutheights <- rep(cutheights,length(category_name))
  pr_table
}

plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- ggplot(plot.thyroid, aes(x = cutheights, y = density, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("# of edges")+ggtitle("Thyroid")

plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- ggplot(plot.lung, aes(x = cutheights, y = density, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("# of edges")+ggtitle("Lung")

plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = cutheights, y = density, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("# of edges")+ggtitle("Whole Blood")


fig4.wgcna <- plot_grid(plot.blood + xlim(1.0,0.9) + theme(legend.position="none"),
                        plot.lung + xlim(1.0,0.9) +  theme(legend.position="none"),
                        plot.thyroid + xlim(1.0,0.9) + theme(legend.position="none"),
                        align = 'vh',
                        labels = c("a", "b", "c"),
                        hjust = -1,
                        nrow = 1
)
legend.wgcna<- get_legend(plot.lung +
                            theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
                                  legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1,"line")) +
                            guides(colour = guide_legend(override.aes = list(size= 1)), fill=guide_legend("type")))

fig4.a <- plot_grid( fig4.wgcna, legend.wgcna, rel_widths = c(3, .4))

## Glasso
select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$type %in% category_name),]
  pr_table$type <- factor(pr_table$type, levels = category_name)
  pr_table$lambda <- rep(lambda,length(category_name))
  pr_table
}


plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- ggplot(plot.thyroid, aes(x = lambda, y = density, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("# of edges")+ggtitle("Thyroid")

plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- ggplot(plot.lung, aes(x = lambda, y = density, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("# of edges")+ggtitle("Lung")

plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = lambda, y = density, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("# of edges")+ggtitle("Whole Blood")


fig4.glasso <- plot_grid(plot.blood + xlim(0.3,1.0) + theme(legend.position="none"),
                         plot.lung + xlim(0.3,1.0) +  theme(legend.position="none"),
                         plot.thyroid + xlim(0.3,1.0) + theme(legend.position="none"),
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

pdf("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig3.pdf", height = 4.5, width = 7.2)
print(fig4)
dev.off()
