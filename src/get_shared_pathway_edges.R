### BIOCARTA
pathways.fn <- "../data/genesets/biocarta2016.txt"
## Read genesets
g.sets <- read.delim(pathways.fn, header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL # second column is NA
names.gsets <- rownames(g.sets)
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) sort(strsplit(x,',')[[1]]))
names(g.sets) <- names.gsets
genes.inpathways <- g.sets

true.positive.list.biocarta2016 <- lapply(genes.inpathways, function(x){
  if(length(x) > 1){
    pathway.edge <- t(combn(sort(x),2))
    pathway.edge <- paste(pathway.edge[,1], pathway.edge[,2], sep = "_")
  }else{
    pathway.edge <- NA
  }
  pathway.edge
})

true.positive.list.biocarta2016 <- unique(unlist(true.positive.list.biocarta2016))
true.positive.list.biocarta2016 <- true.positive.list.biocarta2016[which(!is.na(true.positive.list.biocarta2016))]
print("Total real edgelist size:")
print(length(true.positive.list.biocarta2016))

### KEGG
pathways.fn <- "../data/genesets/kegg2016.txt"



## Read genesets
g.sets <- read.delim(pathways.fn, header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL # second column is NA
names.gsets <- rownames(g.sets)
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) sort(strsplit(x,',')[[1]]))
names(g.sets) <- names.gsets
genes.inpathways <- g.sets

true.positive.list.kegg2016 <- lapply(genes.inpathways, function(x){
  if(length(x) > 1){
    pathway.edge <- t(combn(sort(x),2))
    pathway.edge <- paste(pathway.edge[,1], pathway.edge[,2], sep = "_")
  }else{
    pathway.edge <- NA
  }
  pathway.edge
})

true.positive.list.kegg2016 <- unique(unlist(true.positive.list.kegg2016))
true.positive.list.kegg2016 <- true.positive.list.kegg2016[which(!is.na(true.positive.list.kegg2016))]
print("Total real edgelist size:")
print(length(true.positive.list.kegg2016))

## REACTOME
pathways.fn <- "../data/genesets/reactome2016.txt"



## Read genesets
g.sets <- read.delim(pathways.fn, header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL # second column is NA
names.gsets <- rownames(g.sets)
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) sort(strsplit(x,',')[[1]]))
names(g.sets) <- names.gsets
genes.inpathways <- g.sets

true.positive.list.reactome2016 <- lapply(genes.inpathways, function(x){
  if(length(x) > 1){
    pathway.edge <- t(combn(sort(x),2))
    pathway.edge <- paste(pathway.edge[,1], pathway.edge[,2], sep = "_")
  }else{
    pathway.edge <- NA
  }
  pathway.edge
})

true.positive.list.reactome2016 <- unique(unlist(true.positive.list.reactome2016))
true.positive.list.reactome2016 <- true.positive.list.reactome2016[which(!is.na(true.positive.list.reactome2016))]
print("Total real edgelist size:")
print(length(true.positive.list.reactome2016))


## PID
pathways.fn <- "../data/genesets/pid2016.txt"



## Read genesets
g.sets <- read.delim(pathways.fn, header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL # second column is NA
names.gsets <- rownames(g.sets)
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) sort(strsplit(x,',')[[1]]))
names(g.sets) <- names.gsets
genes.inpathways <- g.sets

true.positive.list.pid2016 <- lapply(genes.inpathways, function(x){
  if(length(x) > 1){
    pathway.edge <- t(combn(sort(x),2))
    pathway.edge <- paste(pathway.edge[,1], pathway.edge[,2], sep = "_")
  }else{
    pathway.edge <- NA
  }
  pathway.edge
})

true.positive.list.pid2016 <- unique(unlist(true.positive.list.pid2016))
true.positive.list.pid2016 <- true.positive.list.pid2016[which(!is.na(true.positive.list.pid2016))]
print("Total real edgelist size:")
print(length(true.positive.list.pid2016))


total.true.positive <- c(true.positive.list.biocarta2016, true.positive.list.kegg2016, true.positive.list.reactome2016, true.positive.list.pid2016)

table_true_positives <- table(total.true.positive)
two_pathways <- do.call(rbind, strsplit(names(table_true_positives)[table_true_positives >=2],"_"))
write.table(two_pathways, file = "../data/genesets/edges_in_twopathways.txt")

