rm(list = ls())

setwd("/work-zfs/abattle4/parsana/networks_correction/")

library(reshape2)
library(dplyr)
library(ggplot2)
library(recount)

inputargs <- commandArgs(TRUE)
tiss <- inputargs[1]
pathways.fn <- inputargs[2]
plot.dir <- inputargs[3]
res.dir <- inputargs [4]
save.fn <- inputargs[5]

type.exp <- c("pc", "halfpc", "quarterpc", "rin", "gc", "mc", "exonicRate", "raw")

  # get gene ids - symbol mapping from recount dataset

  load("data/pc_corrected.Rdata")
  dat.gene.symbol <- rowData(dat.expr[[tiss]])
  head(dat.gene.symbol)
  dat.gene.symbol <- sapply(dat.gene.symbol$symbol, function(x) x[1])
  dat.gene.symbol <- data.frame(gene_id = names(dat.gene.symbol), gene_symbol = dat.gene.symbol, stringsAsFactors = F)
  rm(dat.expr)

   ## Read genesets
    g.sets <- read.delim(pathways.fn, header = F, stringsAsFactors = F, row.names = 1)
    g.sets$V2 <- NULL # second column is NA
    names.gsets <- rownames(g.sets)
    g.sets <- t(g.sets)
    g.sets <- sapply(g.sets, function(x) sort(strsplit(x,',')[[1]]))
    names(g.sets) <- names.gsets
    
    ## select genes in pathways that are also present in the set of variable genes
    genes.inpathways <- lapply(g.sets, function(x,y){
      genes.inset <- x[which(x %in% y)]
      genes.inset
      }, dat.gene.symbol$gene_symbol)

    unique.gene.symbols.inpathways <- unique(unlist(genes.inpathways))

    true.positive.list <- lapply(genes.inpathways, function(x){
      if(length(x) > 1){
        pathway.edge <- t(combn(sort(x),2))
        pathway.edge <- paste(pathway.edge[,1], pathway.edge[,2], sep = "_")
      }else{
        pathway.edge <- NA
      }
      pathway.edge
      })
      
    true.positive.list <- unique(unlist(true.positive.list))
    true.positive.list <- true.positive.list[which(!is.na(true.positive.list))]
    print("Total real edgelist size:")
    print(length(true.positive.list))


  tiss.net <- lapply(type.exp, function(x,y,z){
    print(paste("Loading dataset", y, x))
    load(paste("networks/", x, "/",y, "_glasso_networks.Rdata", sep = ""))
    

    net.edges <- lapply(dat.net, function(eachNet, z_infunc){
      if(all(sub('(^[^.]+)\\.(.*)$','\\1',colnames(eachNet),"") == z_infunc$gene_id)){
        rownames(eachNet) <- z_infunc$gene_symbol
        colnames(eachNet) <- z_infunc$gene_symbol
        na.idx <- which(is.na(rownames(eachNet)))
        eachNet <- eachNet[-na.idx,-na.idx]
        eachNet[lower.tri(eachNet)] <- t(eachNet)[lower.tri(eachNet)]
        sorted.gene.order <- order(rownames(eachNet))
        eachNet <- eachNet[sorted.gene.order, sorted.gene.order]
        eachNet[lower.tri(eachNet)] <- NA
        eachNet <- melt(eachNet, na.rm = T)
        eachNet <- paste(eachNet$Var1, eachNet$Var2, sep = "_")
        eachNet <- unique(eachNet)
    }else{
      print("Gene order and mapping error. Please manually check!")
    }
      eachNet
      }, z)
    net.edges
  },tiss, dat.gene.symbol)

  names(tiss.net) <- type.exp
  
  type.net <- vector("list", length = length(type.exp))
  names(type.net) <- type.exp 
  for(t in type.exp){
    print(t)
    type.net[[t]] <- lapply(tiss.net[[t]], function(x,z){
      total.positives <- length(x)
      tp <- length(intersect(x,z)) # present in both network and pathways
      fn <- length(setdiff(z,x)) # present in pathways missing in network
      fp <- length(setdiff(x,z)) # present in network absent in pathways
      precision <- tp/(tp+fp)
      recall <- tp/(tp+fn)
      # c(tp, fp, fn)
      return(c(precision, recall, total.positives))
    }, true.positive.list)
  }



    type.net.bind <- mapply(function(x,y){
      x <- do.call(rbind, x)
      colnames(x) <- c("precision", "recall", "density")
      x <- data.frame(x)
      x$type <- y
      x
      }, type.net, as.list(type.exp), SIMPLIFY = FALSE)



  pr.plot <- do.call(rbind, type.net.bind)
  pr.plot$type <- factor(pr.plot$type, levels = c("pc", "halfpc", "quarterpc", "rin", "gc", "mc", "exonicRate", "raw"), labels = c("PC", "half-PC", "quarter-PC", "RIN", "gene GC%", "multi-covariate", "exonic rate", "uncorrected"))
  # plot precision and recall

  fig_pr <- ggplot(pr.plot, aes(x = recall, y = precision, col = type))+ geom_point(size = 0.1) + ggtitle(tiss)
  png(paste(plot.dir, "/PR/glasso_networks_", save.fn, ".png", sep = ""), height = 2, width = 4, units = "in", res = 400)
  print(fig_pr)
  dev.off()

  ## save file
  saveRDS(pr.plot, file = paste(res.dir, "/PR/pr_density_glasso_networks_", save.fn, ".Rds", sep = "" ))
