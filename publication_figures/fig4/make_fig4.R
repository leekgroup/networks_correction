rm(list = ls())
load("fig4-wgcna.RData")
load("fig4-glasso.RData")
library(ggplot2)
library(cowplot)
## Read files
theme_set(theme_cowplot(font_size=9)) # reduce default font size


#### WGCNA #####
plot.wgcna.thyroid <- ggplot(plot.wgcna.thyroid, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7))+
	xlab("Cutheight") + ylab("# of edges")+ggtitle("Thyroid")



plot.wgcna.muscle <- ggplot(plot.wgcna.muscle, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7)) +
	xlab("Cutheight") + ylab("# of edges")+ggtitle("Muscle - Skeletal")


plot.wgcna.lung <- ggplot(plot.wgcna.lung, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7), legend.title=element_blank())+
	xlab("Cutheight") + ylab("# of edges")+ggtitle("Lung")


plot.wgcna.blood <- ggplot(plot.wgcna.blood, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7))+
	xlab("Cutheight") + ylab("# of edges")+ggtitle("Whole Blood")


plot.wgcna.sub <- ggplot(plot.wgcna.sub, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7))+
	xlab("Cutheight") + ylab("# of edges")+ggtitle("Adipose - Subcutaneous")

fig4.wgcna <- plot_grid(plot.wgcna.sub + xlim(1.0,0.9) + theme(legend.position="none"),
	plot.wgcna.thyroid + xlim(1.0,0.9) +  theme(legend.position="none"),
	plot.wgcna.lung + xlim(1.0,0.9) + theme(legend.position="none"),
	align = 'vh',
           labels = c("a", "b", "c"),
           hjust = -1,
           nrow = 1
           )
legend.wgcna <- get_legend(plot.wgcna.lung +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1)), fill=guide_legend("type")))

fig4.a <- plot_grid( fig4.wgcna, legend.wgcna, rel_widths = c(3, .4))

##### GLASSO #####
plot.glasso.thyroid <- ggplot(plot.glasso.thyroid, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7))+
	xlab("Penalty") + ylab("# of edges")+ggtitle("Thyroid")



plot.glasso.muscle <- ggplot(plot.glasso.muscle, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
	scale_color_manual(labels = c("T999", "T888")) +
#	theme(text = element_text(size=7)) +
	xlab("Penalty") + ylab("# of edges")+ggtitle("Muscle - Skeletal")


plot.glasso.lung <- ggplot(plot.glasso.lung, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7), legend.title=element_blank())+
	xlab("Penalty") + ylab("# of edges")+ggtitle("Lung")


plot.glasso.blood <- ggplot(plot.glasso.blood, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7))+
	xlab("Penalty") + ylab("# of edges")+ggtitle("Whole Blood")


plot.glasso.sub <- ggplot(plot.glasso.sub, aes(x = Var1, y = value, colour = Var2)) + geom_point(size = 0.3) + 
#	theme(text = element_text(size=7))+
	xlab("Penalty") + ylab("# of edges")+ggtitle("Adipose - Subcutaneous")

fig4.glasso <- plot_grid(plot.glasso.sub + xlim(0.3,1.0) + theme(legend.position="none"),
	plot.glasso.thyroid + xlim(0.3,1.0) +  theme(legend.position="none"),
	plot.glasso.lung + xlim(0.3,1.0) + theme(legend.position="none"),
	align = 'vh',
           labels = c("d", "e", "f"),
           hjust = -1,
           nrow = 1
           )
legend.glasso <- get_legend(plot.glasso.lung +
	theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
	legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1,"line")) + 
	guides(colour = guide_legend(override.aes = list(size= 1)),fill=guide_legend("type")))

fig4.b <- plot_grid( fig4.glasso, legend.glasso, rel_widths = c(3, .4))

fig4 <- plot_grid(fig4.a, fig4.b, nrow = 2)

pdf("fig4.pdf", height = 4.5, width = 7.2)
print(fig4)
dev.off()

