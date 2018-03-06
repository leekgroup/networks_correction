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
  ## for each dataset
  precision <- matrix(ncol = 5, nrow = 50)
  recall <- matrix(ncol = 5, nrow = 50)

  version.data <- c(pc, half.pc, quarter.pc, rin, raw)
  for(j in 1:length(version.data)){
    load(paste(version.data[j],"wgcna_networks.RData", sep = ""))
    wgcna.networks <- wgcna.networks[[fn]]
    modules.genes <- vector("list",length=length(wgcna.networks))
    networks.list <- vector("list",length=length(wgcna.networks))
    # tp.fp <- vector("numeric", length = length(wgcna.networks))
    for(i in 1:length(wgcna.networks)){
      modules.genes[[i]] <- sapply(sort(unique(wgcna.networks[[i]]$colors))[-1], function(x,y,z,q){
        y.withgenenames <- y$colors[z]
        q[which(y.withgenenames == x)]
          }, wgcna.networks[[i]], genes.network.index, gene.symbols.innetwork)

      ## convert modules to fully connected graph
      networks.list[[i]] <- lapply(modules.genes[[i]], function(x){
      g <- make_full_graph(length(x))
      V(g)$name <- x
      get.edgelist(g)
      })

      networks.list[[i]] <- do.call(rbind, networks.list[[i]])
      networks.list[[i]] <- unique(data.frame(networks.list[[i]]))
      networks.list[[i]] <- graph.data.frame(networks.list[[i]], directed = FALSE)
      # rm(networks.list)
    }
    
    precision.recall <- sapply(networks.list, function(x,y){
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
  colnames(precision) <- c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected")
  rownames(precision) <- cutheights
  plot.precision <- melt(precision)

  colnames(recall) <- c("PC corrected","half-PC","quarter-PC", "RIN", "uncorrected")
  rownames(recall) <- cutheights
  plot.recall <- melt(recall)

  plot.both <- cbind(plot.precision, plot.recall[,3])
  colnames(plot.both) <- c("Cutheights", "type", "precision", "recall")
  plot.both
}

#### Run function
plot.thyroid <- plot_precision_recall("Thyroid", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.muscle <- plot_precision_recall("Muscle", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.lung <- plot_precision_recall("Lung", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.blood <- plot_precision_recall("Blood", tp.fn, genes.network.withnames, pc.gene.symbols)

plot.sub <- plot_precision_recall("Subcutaneous", tp.fn, genes.network.withnames, pc.gene.symbols)

save(plot.thyroid, plot.muscle, plot.lung, plot.blood, plot.sub, file = "edge_filtered-wgcna.RData")
