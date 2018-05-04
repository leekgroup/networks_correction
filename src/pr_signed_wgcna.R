# ---
# title: "Correlation networks"
# output: html_notebook
# ---


# require("knitr")
# opts_knit$set(root.dir = "/work-zfs/abattle4/parsana/networks_correction/")
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

type.exp <- c("raw", "rin", "quarterpc", "halfpc", "pc")

  # get gene ids - symbol mapping from recount dataset

  load("data/raw_subset.Rdata")
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
    # all.genes.inset <- unlist(g.sets)
    # names(all.genes.inset) <- NULL
    # all.genes.inset <- unique(all.genes.inset)
    # all.genesinset.subset <- all.genes.inset[which(all.genes.inset %in% dat.gene.symbol$gene_symbol)] # This is the intersection of all genes in our analysis also present in the genesets and pathways we are using to evaluate the networks
    
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


  # for each network within the tissue generate a fully connected subgraph
  tiss.net <- lapply(type.exp, function(x,y,z){
    print(paste("Loading network", x))
    load(paste("networks", x, "signed_wgcna_networks.Rdata", sep = "/"))
    
    # get module assignments for each cut-off networks
    this.net <- lapply(dat.net[[y]], function(eachNet, gene.symbol){
      eachNet <- eachNet$colors
      names(eachNet) <- gene.symbol$gene_symbol ## names for each entry in the vector -- gene names
      eachNet
    }, z)

    dat.module.network <- lapply(this.net, function(eachNet){
      total.num.modules <- sort(unique(eachNet))[-1] ## remove gray modules
      module.genes.eachNet <- lapply(total.num.modules, function(eachModule, this.network){
        genes.in.module <- names(this.network)[which(this.network == eachModule)]
        genes.in.module <- sort(genes.in.module)
        if(any(is.na(genes.in.module))){
          genes.in.module <- genes.in.module[-which(is.na(genes.in.module))]
        }
        module.network <- t(combn(unique(genes.in.module), 2)) # only keep unique genes
        module.network <- paste(module.network[,1], module.network[,2], sep = "_")
        module.network
        }, eachNet)
      unlist(module.genes.eachNet)
      })
    dat.module.network
  },tiss, dat.gene.symbol)

  names(tiss.net) <- type.exp


  type.net <- vector("list", length = 5)
  names(type.net) <- type.exp 
  for(t in type.exp){
    print(t)
    type.net[[t]] <- lapply(tiss.net[[t]], function(x, z){
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

    # type.net.bind <- lapply(type.net.bind, function(x,y){
    #   rownames(x) <- y
    #   x
    #   }, threshold.values)

  # type.net.bind[[1]]$type <- "uncorrected"
  # type.net.bind[[2]]$type <- "RIN"
  # type.net.bind[[3]]$type <- "quarterPC"
  # type.net.bind[[4]]$type <- "halfPC"
  # type.net.bind[[5]]$type <- "PC"

  pr.plot <- do.call(rbind, type.net.bind)
  pr.plot$type <- factor(pr.plot$type, levels = c("pc", "halfpc", "quarterpc", "rin", "raw"), labels = c("PC", "half-PC", "quarter-PC", "RIN", "uncorrected"))

  # plot precision and recall

  fig_pr <- ggplot(pr.plot, aes(x = recall, y = precision, col = type))+ geom_point(size = 0.3) + ggtitle(tiss) + xlim(0, 0.20)+ ylim(0.0, 0.40)
  png(paste(plot.dir, "/PR/signed_wgcna_networks_", tiss, ".png", sep = ""), height = 2, width = 4, units = "in", res = 400)
  print(fig_pr)
  dev.off()

  ## save file
  saveRds(pr.plot, file = paste(res.dir, "/PR/signed_pr_density_wgcna_", tiss, ".Rds", sep = "" ))
