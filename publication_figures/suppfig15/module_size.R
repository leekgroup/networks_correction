library(reshape2)
library(ggplot2)
modsize = readRDS("wgcna_module_size.Rds")

# hist(unlist(lapply(modsize[[1]], function(y) sapply(y, function(x) length(x)))), 
#      breaks = 50, col = rgb(1, 0.75, 0.14, 0.5))
# 
# hist(unlist(lapply(modsize[[4]], function(y) length(y))), 
#      col = rgb(0.39, 0.58, 0.92, 0.5), 
#      add = T, breaks = 20)

modraw <- modsize[[1]][46:50,]
modpc <-  modsize[[4]][46:50,]

modraw <- lapply(seq_len(ncol(modraw)), function(i) modraw[,i])
modpc <- lapply(seq_len(ncol(modpc)), function(i) modpc[,i])

grayraw <- sapply(modraw, function(x) sapply(x, function(y) mean(y[-1])))
graypc <- sapply(modpc, function(x) sapply(x, function(y) mean(y[-1])))
colnames(grayraw)<- colnames(modsize[[1]])
colnames(graypc) <- colnames(modsize[[1]])
grayraw <- melt(grayraw[,c(1:5)])
graypc <- melt(graypc[,c(1:5)])
grayraw$cutheights <- rep(seq(0.9,1.0,length.out = 50)[46:50], 5)
graypc$cutheights <-  rep(seq(0.9,1.0,length.out = 50)[46:50], 5)
graypc$Tissue <- graypc$Var2
grayraw$Tissue <- grayraw$Var2

# grayraw <- sapply(modraw, function(x) unlist(lapply(x, function(y) y[-1])))
# graypc <- sapply(modpc, function(x) unlist(lapply(x, function(y) y[-1])))
# 
# names(grayraw) <- colnames(modsize[[1]])
# names(graypc) <- colnames(modsize[[4]])
# 
# grayraw <- melt(grayraw[1:5])
# graypc <- melt(graypc[1:5])
# 

grayraw$Type <- "uncorrected"
graypc$Type <- "PC"
# graypc$Tissue <- graypc$L1
# grayraw$Tissue <- grayraw$L1

graymerged <- rbind(grayraw, graypc)

ggplot(graymerged, aes(x = cutheights, y = value, col = Type,
                       shape = Tissue))+
  geom_line(aes(linetype= Type))+
  geom_point()+
  xlab("Cut-heights")+
  ylab("average # genes per module")+
  theme_classic()


ggsave(filename = "average_module_size.png", width = 5, height = 4, units = "in", dpi = 600)
