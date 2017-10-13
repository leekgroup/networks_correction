source("../../../src/config")
library(cowplot)
load("tft-glasso.RData")
## Read files
theme_set(theme_cowplot(font_size=12)) # reduce default font size

plot.thyroid <- ggplot(plot.thyroid, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
#  theme(text = element_text(size=7))+
  xlab("Recall") + ylab("Precision")+ggtitle("Thyroid")


plot.muscle <- ggplot(plot.muscle, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
#  theme(text = element_text(size=7)) +
  xlab("Recall") + ylab("Precision")+ggtitle("Muscle - Skeletal")

plot.lung <- ggplot(plot.lung, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
  theme(legend.title=element_blank())+
  xlab("Recall") + ylab("Precision")+ggtitle("Lung")

plot.blood <- ggplot(plot.blood, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
#  theme(text = element_text(size=7))+
  xlab("Recall") + ylab("Precision")+ggtitle("Whole Blood")

plot.sub <- ggplot(plot.sub, aes(x = recall, y = precision, colour = type)) + geom_point(size = 0.3) + 
#  theme(text = element_text(size=7))+
  xlab("Recall") + ylab("Precision")+ggtitle("Adipose - Subcutaneous")


legend <- get_legend(plot.lung +
        theme(legend.key = element_rect(color = "black", linetype = "solid", size = 0.5),
        legend.key.size = unit(0.3, "cm"), legend.key.height=unit(1.5,"line")) + 
        guides(colour = guide_legend(override.aes = list(size= 1))))

fig2 <- plot_grid(plot.sub + xlim(0,0.015) + ylim(0, 0.015) + theme(legend.position="none"),
        plot.thyroid + xlim(0,0.015) + ylim(0, 0.015) +  theme(legend.position="none"),
        plot.lung + xlim(0,0.015) + ylim(0, 0.015) + theme(legend.position="none"),
        plot.muscle + xlim(0,0.015) + ylim(0, 0.015) + theme(legend.position="none"),
        plot.blood + xlim(0,0.015) + ylim(0, 0.015) + theme(legend.position="none"),
        legend,
        # align = 'vh',
           labels = c("a", "b", "c", "d", "e", ""),
           hjust = -1,
           nrow = 3
           )


pdf("supp_fig10.pdf", height = 7.2, width = 7.2)
print(fig2)
dev.off()
