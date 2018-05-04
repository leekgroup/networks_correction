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
threshold.values <- eval(parse(text = inputargs [2]))
pathways.fn <- inputargs[3]
plot.dir <- inputargs[4]
res.dir <- inputargs [5]

type.exp <- c("pc", "halfpc", "quarterpc", "rin", "gc", "mc", "exonicRate", "raw")

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


  tiss.net <- lapply(type.exp, function(x,y,z){
    print(paste("Loading dataset", x))
    load(paste("networks", x, "correlation_networks.Rdata", sep = "/"))
    dat.net <- dat.net[[y]]
    if(all(sub('(^[^.]+)\\.(.*)$','\\1',colnames(dat.net),"") == z$gene_id)){
      rownames(dat.net) <- z$gene_symbol
      colnames(dat.net) <- z$gene_symbol
      sorted.gene.order <- order(rownames(dat.net))
      dat.net <- dat.net[sorted.gene.order, sorted.gene.order]
    }else{
      print("Gene order and mapping error. Please manually check!")
    }
    diag(dat.net) <- NA
    dat.net[lower.tri(dat.net)] <- NA
    dat.net <- melt(dat.net, na.rm = T)
    dat.net$edge <- paste (dat.net$Var1, dat.net$Var2, sep = "_")
    print(head(dat.net))
    dat.net
  },tiss, dat.gene.symbol)

  names(tiss.net) <- type.exp
  
  type.net <- vector("list", length = 5)
  names(type.net) <- type.exp 
  for(t in type.exp){
    print(t)
    type.net[[t]] <- lapply(threshold.values, function(x,y,z){
      thr.net <- y %>% filter(value >= x) 
      thr.net <- unique(thr.net$edge)
      total.positives <- length(thr.net)
      #tp.net <- thr.net %>%
      #filter(edge %in% z)
      fn <- length(setdiff(z,thr.net)) # present in z missing in x
      tp <- length(intersect(thr.net,z))
      fp <- length(setdiff(thr.net,z))
      precision <- tp/(tp+fp)
      recall <- tp/(tp+fn)
      # c(tp, fp, fn)
      return(c(precision, recall, total.positives))
    }, tiss.net[[t]], true.positive.list)
  }



    type.net.bind <- mapply(function(x,y){
      x <- do.call(rbind, x)
      colnames(x) <- c("precision", "recall", "density")
      x <- data.frame(x)
      x$type <- y
      x
      }, type.net, as.list(type.exp), SIMPLIFY = FALSE)

    type.net.bind <- lapply(type.net.bind, function(x,y){
      x$threshold <- threshold.values
      x
      }, threshold.values)


  pr.plot <- do.call(rbind, type.net.bind)
  pr.plot$type <- factor(pr.plot$type, levels = c("pc", "halfpc", "quarterpc", "rin", "gc", "mc", "exonicRate", "raw"), labels = c("PC", "half-PC", "quarter-PC", "RIN", "gene GC%", "multi-covariate", "exonic rate", "uncorrected"))

  # plot precision and recall

  fig_pr <- ggplot(pr.plot, aes(x = recall, y = precision, col = type))+ geom_point(size = 0.3) + ggtitle(tiss)
  png(paste(plot.dir, "/PR/correlation_networks_", tiss, ".png", sep = ""), height = 2, width = 4, units = "in", res = 400)
  print(fig_pr)
  dev.off()

  ## save file
  saveRDS(pr.plot, file = paste(res.dir, "/PR/pr_density_correlation_networks_", tiss, ".Rds", sep = "" ))
