library(reshape2)
library(ggplot2)

modsize = readRDS("wgcna_module_size.Rds")

# hist(unlist(lapply(modsize[[1]], function(y) sapply(y, function(x) length(x)))), 
#      breaks = 50, col = rgb(1, 0.75, 0.14, 0.5))
# 
# hist(unlist(lapply(modsize[[4]], function(y) length(y))), 
#      col = rgb(0.39, 0.58, 0.92, 0.5), 
#      add = T, breaks = 20)

modraw <- modsize[[1]][c(46:50),]
modpc <-  modsize[[4]][c(46:50),]

modraw <- lapply(seq_len(ncol(modraw)), function(i) modraw[,i])
modpc <- lapply(seq_len(ncol(modpc)), function(i) modpc[,i])

grayraw <- sapply(modraw, function(x) sapply(x, function(y) length(y)-1))
graypc <- sapply(modpc, function(x) sapply(x, function(y) length(y)-1))

colnames(grayraw)<- colnames(modsize[[1]])
colnames(graypc) <- colnames(modsize[[1]])
 
grayraw <- melt(grayraw[,c(1:5)])
graypc <- melt(graypc[,c(1:5)])

grayraw$cutheights <- rep(seq(0.9,1.0,length.out = 50)[46:50], 5)
grayraw$Type <- "uncorrected"
graypc$cutheights <-  rep(seq(0.9,1.0,length.out = 50)[46:50], 5)
graypc$Type <- "PC"
graypc$Tissue <- graypc$Var2
grayraw$Tissue <- grayraw$Var2

graymerged <- rbind(grayraw, graypc)

p <- ggplot(graymerged, aes(x = cutheights, y = value, col = Type, 
                       shape = Tissue))+
  geom_line(aes(linetype= Type))+
  geom_point()+
  xlab("Cut-heights")+
  ylab("# of modules")+
  theme_classic()

ggsave(filename = "num_modules.png", plot = p, width = 5, height = 4, units = "in", dpi = 1500)
