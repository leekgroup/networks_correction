library(cowplot)
library(ggplot2)
library(parallel)
library(igraph)
library(reshape2)
theme_set(theme_cowplot(font_size=9))

create.igraph <- function(network){
    # network[which(network != 0)] <- 1
    diag(network) <- 0
    network[network!=0] <- 1
    graph_from_adjacency_matrix(network, mode = "undirected")
}


fn <- dir("../../networks/", recursive=T, full.names = T)
fn <- fn[grep("glasso", fn)]
fn <- fn[grep(paste("raw", "rin", "mc", "/pc/", sep = "|"), fn)]

igraph_net <- mclapply(fn, function(x){
        print(x)
        load(x)
        net.igraph <- lapply(dat.net[1:10], function(eachNet){
                eachNet[lower.tri(eachNet)] <- t(eachNet)[lower.tri(eachNet)]
                create.igraph(eachNet)
                })
        net.igraph
        }, mc.cores = 16)

# igraph_net <- lapply(igraph_net, function(x,y){
#         y <- y
#         this_net <- lapply(x, function(thisx, thisy){
#                 V(thisx)$name <- thisy
#                 thisx
#                 }, y)
#         this_net
#         }, dat.gene.symbol$gene_symbol)


nodes_with_20 <- mclapply(igraph_net, function(x)
                sapply(x, function(y) sum(degree(y) >=20)), mc.cores = 16)

names(nodes_with_20) <- fn

raw <- nodes_with_20[grep("raw", fn)]
rin <- nodes_with_20[grep("rin", fn)]
mc <- nodes_with_20[grep("mc", fn)]
pc <- nodes_with_20[grep("/pc/", fn)]

hub_net <- melt(data.frame(raw, rin, mc, pc))

hub_net$tissue <- NA
hub_net$tissue[grep("Artery", hub_net$variable)] <- "Tibial Artery"
hub_net$tissue[grep("Blood", hub_net$variable)] <- "Whole Blood"
hub_net$tissue[grep("Lung", hub_net$variable)] <- "Lung"
hub_net$tissue[grep("Muscle", hub_net$variable)] <- "Muscle"
hub_net$tissue[grep("Subcutaneous", hub_net$variable)] <- "Adipose Subcutaneous"
hub_net$tissue[grep("Nerve", hub_net$variable)] <- "Nerve Tibial"
hub_net$tissue[grep("Thyroid", hub_net$variable)] <- "Thyroid"
hub_net$tissue[grep("Skin", hub_net$variable)] <- "Sun exposed Skin"

hub_net$version <- NA
hub_net$version[grep("raw", hub_net$variable)] <- "Uncorrected"
hub_net$version[grep("rin", hub_net$variable)] <- "RIN"
hub_net$version[grep("mc", hub_net$variable)] <- "multi-covariate"
hub_net$version[grep("..pc.", hub_net$variable)] <- "PC"


select_category <- function(category_name, pr_table){
  pr_table <- pr_table[which(pr_table$version %in% category_name),]
  pr_table$version <- factor(pr_table$version, levels = category_name)
  pr_table
}

which_version <- c("Uncorrected", "RIN", "multi-covariate", "PC")

plot_this <- select_category(which_version, hub_net)

thisplot <- ggplot(aes(y = value, x = tissue, fill = version),
        data = plot_this)+
geom_boxplot()+ ylab("# Nodes with >=20 neighbors")+ xlab("Tissue") + theme_classic()+theme(axis.text.x = element_text(angle = 90, hjust = 1))

pdf("../suppfig13.pdf", height = 7, width = 12)
print(thisplot)
dev.off()

