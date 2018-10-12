library(cowplot)
library(ggplot2)
theme_set(theme_cowplot(font_size=9))
lambda <- seq(0.3,1.0, length.out = 50)
cat.plot <- c("PC", "half-PC", "uncorrected")

# select category to plot
select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$type %in% category_name),]
  pr_table$type <- factor(pr_table$type, levels = category_name)
  pr_table$lambda <- rep(lambda,length(category_name))
  pr_table
}
plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- ggplot(plot.thyroid, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size =0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("Thyroid") + scale_color_manual(values = c("#B22222", "#006400", "#800080"))
plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- ggplot(plot.lung, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("Lung")+ scale_color_manual(values = c("#B22222", "#006400", "#800080"))
plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("Whole Blood")+ scale_color_manual(values = c("#B22222", "#006400","#800080"))
plot.skin <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_skin.Rds")
plot.skin <- select_category(cat.plot, plot.skin)
plot.skin <- ggplot(plot.skin, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("skin")+ scale_color_manual(values = c("#B22222", "#006400", "#800080"))
plot.muscle <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_muscle.Rds")
plot.muscle <- select_category(cat.plot, plot.muscle)
plot.muscle <- ggplot(plot.muscle, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("muscle")+ scale_color_manual(values = c("#B22222", "#006400", "#800080"))
plot.subcutaneous <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_subcutaneous.Rds")
plot.subcutaneous <- select_category(cat.plot, plot.subcutaneous)
plot.subcutaneous <- ggplot(plot.subcutaneous, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("subcutaneous")+ scale_color_manual(values = c("#B22222", "#006400", "#800080"))
plot.artery <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_artery.Rds")
plot.artery <- select_category(cat.plot, plot.artery)
plot.artery <- ggplot(plot.artery, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("artery")+ scale_color_manual(values = c("#B22222", "#006400", "#800080"))
plot.nerve <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_nerve.Rds")
plot.nerve <- select_category(cat.plot, plot.nerve)
plot.nerve <- ggplot(plot.nerve, aes(x = lambda, y = 1-precision, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FDR")+ggtitle("nerve")+ scale_color_manual(values = c("#B22222", "#006400", "#800080"))
###############################
legend <- get_legend(plot.lung +
                       theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
                             legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) +
                       guides(colour = guide_legend(override.aes = list(size= 1))))


fig2 <- plot_grid(plot.blood + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  plot.lung + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  plot.thyroid + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  plot.muscle + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  plot.artery + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  plot.skin + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  plot.nerve + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  plot.subcutaneous + xlim(0.3,1.0) + ylim(0, 1) + theme(legend.position="none"),
                  legend,
                  align = 'vh',
                  labels = c("a", "b", "c", "d", "e", "f", "g", "h"),
                  hjust = -1,
                  nrow = 3
)

pdf("/work-zfs/abattle4/parsana/networks_correction/publication_figures/suppfig9.pdf", height = 6.5, width = 7.2)
print(fig2)
dev.off()

