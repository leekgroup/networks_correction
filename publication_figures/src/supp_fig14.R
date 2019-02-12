library(cowplot)
library(ggplot2)
theme_set(theme_cowplot(font_size=9))
cutheights <- seq(0.9,1.0, length.out = 50)

cat.plot <- c("uncorrected", "RIN", "multi-covariate", "PC")

# select category to plot
select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$type %in% category_name),]
  pr_table$type <- factor(pr_table$type, levels = category_name)
  pr_table$cutheights <- rep(cutheights,length(category_name))
  pr_table$fnr <- pr_table$false_negatives/ ((4978 * (4978 - 1))/2 - pr_table$density)
  pr_table
}

plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- ggplot(plot.thyroid, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size =0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("Thyroid")
plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- ggplot(plot.lung, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("Lung")
plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("Whole Blood")
plot.skin <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_skin.Rds")
plot.skin <- select_category(cat.plot, plot.skin)
plot.skin <- ggplot(plot.skin, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("skin")
plot.muscle <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_muscle.Rds")
plot.muscle <- select_category(cat.plot, plot.muscle)
plot.muscle <- ggplot(plot.muscle, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("muscle")
plot.subcutaneous <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_subcutaneous.Rds")
plot.subcutaneous <- select_category(cat.plot, plot.subcutaneous)
plot.subcutaneous <- ggplot(plot.subcutaneous, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("subcutaneous")
plot.artery <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_artery.Rds")
plot.artery <- select_category(cat.plot, plot.artery)
plot.artery <- ggplot(plot.artery, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("artery")
plot.nerve <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_wgcna-signed_canonical_nerve.Rds")
plot.nerve <- select_category(cat.plot, plot.nerve)
plot.nerve <- ggplot(plot.nerve, aes(x = cutheights, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("cut-heights") + ylab("FNR")+ggtitle("nerve")
###############################
fig2 <- plot_grid(plot.blood + xlim(0.9,1.0) + ylim(0.045, 0.050) + theme(legend.position="none"),
                  plot.lung + xlim(0.9,1.0) + ylim(0.045, 0.050) + theme(legend.position="none"),
                  # plot.muscle + xlim(0.9,1.0) + + theme(legend.position="none"),
                  # plot.artery + xlim(0.9,1.0) + + theme(legend.position="none"),
                  # plot.skin + xlim(0.9,1.0) + + theme(legend.position="none"),
                  # plot.nerve + xlim(0.9,1.0) + + theme(legend.position="none"),
                  # plot.subcutaneous + xlim(0.9,1.0) + + theme(legend.position="none"),
                  plot.thyroid + xlim(0.9,1.0) + ylim(0.045, 0.050) + theme(legend.position="none"),
                  align = 'vh',
                  labels = c("a", "b", "c"),
                  hjust = -1,
                  nrow = 1
)
legend <- get_legend(plot.lung +
                       theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
                             legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) +
                       guides(colour = guide_legend(override.aes = list(size= 1))))
fig2a <- plot_grid( fig2, legend, rel_widths = c(3, .4))


####################################### Fig 2b glasso ###################################
lambda <- seq(0.3,1.0, length.out = 50)
cat.plot <- c("uncorrected", "RIN", "multi-covariate", "PC")
# select category to plot
select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$type %in% category_name),]
  pr_table$type <- factor(pr_table$type, levels = category_name)
  pr_table$lambda <- rep(lambda,length(category_name))
  pr_table$fnr <- pr_table$false_negatives/ ((4978 * (4978 - 1))/2 - pr_table$density)
  pr_table
}
plot.thyroid <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_thyroid.Rds")
plot.thyroid <- select_category(cat.plot, plot.thyroid)
plot.thyroid <- ggplot(plot.thyroid, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size =0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("Thyroid")
plot.lung <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_lung.Rds")
plot.lung <- select_category(cat.plot, plot.lung)
plot.lung <- ggplot(plot.lung, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("Lung")
plot.blood <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_blood.Rds")
plot.blood <- select_category(cat.plot, plot.blood)
plot.blood <- ggplot(plot.blood, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("Whole Blood")
plot.skin <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_skin.Rds")
plot.skin <- select_category(cat.plot, plot.skin)
plot.skin <- ggplot(plot.skin, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("skin")
plot.muscle <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_muscle.Rds")
plot.muscle <- select_category(cat.plot, plot.muscle)
plot.muscle <- ggplot(plot.muscle, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("muscle")
plot.subcutaneous <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_subcutaneous.Rds")
plot.subcutaneous <- select_category(cat.plot, plot.subcutaneous)
plot.subcutaneous <- ggplot(plot.subcutaneous, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("subcutaneous")
plot.artery <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_artery.Rds")
plot.artery <- select_category(cat.plot, plot.artery)
plot.artery <- ggplot(plot.artery, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("artery")
plot.nerve <- readRDS("/work-zfs/abattle4/parsana/networks_correction/results/PR/pr_density_glasso_canonical_nerve.Rds")
plot.nerve <- select_category(cat.plot, plot.nerve)
plot.nerve <- ggplot(plot.nerve, aes(x = lambda, y  = fnr, colour = type)) + geom_point(size = 0.3) +
  xlab("lambda") + ylab("FNR")+ggtitle("nerve")
###############################
fig3 <- plot_grid(plot.blood + xlim(0.3,1.0) + ylim(0.045, 0.050)+ theme(legend.position="none"),
                  plot.lung + xlim(0.3,1.0) + ylim(0.045, 0.050)+ theme(legend.position="none"),
                  # plot.muscle + xlim(0.3,1.0) + theme(legend.position="none"),
                  # plot.artery + xlim(0.3,1.0) + theme(legend.position="none"),
                  # plot.skin + xlim(0.3,1.0) + theme(legend.position="none"),
                  # plot.nerve + xlim(0.3,1.0) + theme(legend.position="none"),
                  # plot.subcutaneous + xlim(0.3,1.0) + theme(legend.position="none"),
                  plot.thyroid + xlim(0.3,1.0) + ylim(0.045, 0.050) + theme(legend.position="none"),
                  align = 'vh',
                  labels = c("a", "b", "c"),
                  hjust = -1,
                  nrow = 1
)

legend <- get_legend(plot.lung +
                       theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
                             legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) +
                       guides(colour = guide_legend(override.aes = list(size= 1))))
fig2b <- plot_grid( fig3, legend, rel_widths = c(3, .4))

pdf("../suppfig14.pdf", height = 5, width = 7.2)
plot_grid(fig2a, fig2b, nrow = 2)
dev.off()
