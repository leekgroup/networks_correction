source("/work-zfs/abattle4/parsana/networks_correction/src/config")
library(igraph)

## read list of true positive edges present at least in 2 pathway databases
df <- read.delim("../edge_filter/edges_in_twopathways.txt", header = F)
dim(df)
tp.fn <- graph_from_data_frame(df, directed = FALSE)


# PC corrected
load("/work-zfs/abattle4/parsana/networks_correction/data/gtex_half_pc_corrected.Rdata")
###**** REMEMBER 1 is hard coded in the next line ****###
pc.gene.symbols <- sapply(rowData(gtex.half.pc.corrected[[1]])$symbol, function(x) x[[1]][1])
genes.network.withnames <- which(!is.na(pc.gene.symbols))
pc.gene.symbols <- pc.gene.symbols[genes.network.withnames]

plot_precision_recall <- function(tissuename, truep.falsen, genes.network.index, gene.symbols.innetwork ){
  fn <- tissuename
  # fn <- "Subcutaneous"

  version.data <- c(pcglasso, half.pcglasso, quarter.pcglasso, ringlasso, multi3glasso, multi7glasso, rawglasso)
  versions <- c("PC-corrected","half-PC corrected","quarter-PC corrected", "RIN corrected", "multi3", "multi7", "uncorrected")
  ## for each dataset
  precision <- matrix(ncol = length(versions), nrow = 50)
  recall <- matrix(ncol = length(versions), nrow = 50)
    for(j in 1:length(version.data)){
    # j = 3
    ## load dataset
    load(paste(version.data[j], fn, ".Rdata", sep = ""))
    glasso.network <- lapply(glasso.network, f <- function(m) {
        m[lower.tri(m)] <- t(m)[lower.tri(m)]
        m
    }
    )
    glasso.network <- lapply(glasso.network, function(x,y,z){
      x <- x[z,z]
      x[which(is.na(x))] <- 0
      dimnames(x) <- list(y,y)
      x
      }, gene.symbols.innetwork, genes.network.index)

    precision.recall <- sapply(glasso.network, function(x,y){
      x <- graph_from_adjacency_matrix(x, mode = "undirected", diag = F, weighted = T)
      tp <- ecount(graph.intersection(x,y))
      fp <- ecount(graph.difference(x,y))
      fn <- ecount(y) - tp
      precision.infunc <- tp/(tp+fp)
      recall.infunc <- tp/(tp+fn)
      return(c(precision.infunc, recall.infunc))
      }, truep.falsen)

    precision[,j] <- precision.recall[1,]
    recall[,j] <- precision.recall[2,]
  }

  colnames(precision) <- versions
  rownames(precision) <- lambda
  plot.precision <- melt(precision)

  colnames(recall) <- versions
  rownames(recall) <- lambda
  plot.recall <- melt(recall)

  plot.both <- cbind(plot.precision, plot.recall[,3])
  colnames(plot.both) <- c("lambda", "type", "precision", "recall")
  plot.both
}


#### Run function
plot.thyroid <- plot_precision_recall("Thyroid", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.muscle <- plot_precision_recall("Muscle", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.lung <- plot_precision_recall("Lung", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.blood <- plot_precision_recall("Blood", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.sub <- plot_precision_recall("Subcutaneous", tp.fn, genes.network.withnames, pc.gene.symbols)

save(plot.thyroid, plot.muscle, plot.lung, plot.blood, plot.sub, file = "edge_filtered-glasso.RData")
