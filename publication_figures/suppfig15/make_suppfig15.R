library(cowplot)
p1 <- ggdraw() + draw_image("average_module_size.png")
p2 <- ggdraw() + draw_image("num_modules.png")
p3 <- ggdraw() + draw_image("num_genes_gray_modules.png")
p <-plot_grid(p1, p2, p3, ncol = 3, align = "h", labels = c("a", "b", "c"))

pdf("../suppfig15.pdf", height = 3, width = 7)
print(p)
dev.off()
