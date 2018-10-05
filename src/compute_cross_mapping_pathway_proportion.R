library(dplyr)
library(gtools)
# grep protein_coding gencode.v26.GRCh38.genes.gtf| sed 's/;/\t/g' | grep protein_coding | sed 's/\s/\t/g' | cut -f10,19 >../../../parsana/temp/gencode_v26_eid_gname.txt # first run shell script 
# awk ' {split( $0, a, " " ); asort( a ); for( i = 1; i <= length(a); i++ ) printf( "%s ", a[i] ); printf( "\n" ); }' /work-zfs/abattle4/lab_data/annotation/mappability_hg38_gencode26/hg38_cross_mappability_strength.txt | sed 's/\s/\t/g' >hg38_cross_mappability_strength_sorted.txt
pathways.fn <- "/work-zfs/abattle4/parsana/networks_correction/data/genesets/canonical_pathways_merged.txt"
cross_mapping_fn<- "/work-zfs/abattle4/lab_data/annotation/mappability_hg38_gencode26/hg38_cross_mappability_strength.txt"
gencode_protein_coding_fn <- "/work-zfs/abattle4/parsana/temp/gencode_v26_eid_gname.txt"

## Read genesets
g.sets <- read.delim(pathways.fn, header = F, stringsAsFactors = F, row.names = 1)
g.sets$V2 <- NULL # second column is NA
names.gsets <- rownames(g.sets)
g.sets <- t(g.sets)
g.sets <- sapply(g.sets, function(x) sort(strsplit(x,',')[[1]]))
names(g.sets) <- names.gsets

unique.gene.symbols.inpathways <- unique(unlist(g.sets))

true.positive.list <- lapply(g.sets, function(x){
  if(length(x) > 1){
    pathway.edge <- t(combn(sort(x),2))
    # pathway.edge <- paste(pathway.edge[,1], pathway.edge[,2], sep = "_")
  }else{
    pathway.edge <- NA
  }
  pathway.edge
})

true.positive.list <- unique(do.call(rbind,true.positive.list))
# true.positive.list <- true.positive.list[which(!is.na(true.positive.list))]
print("Total real edgelist size:")
print(dim(true.positive.list))
true.positive.list <- as.data.frame(true.positive.list, stringsAsFactors=F)

cross_mapping_genes <- read.delim("/work-zfs/abattle4/parsana/temp/hg38_cross_mappability_strength_sorted.txt", header = F, stringsAsFactors = F)
gencode_gsymbol_id <- read.delim("/work-zfs/abattle4/parsana/temp/gencode_v26_eid_gname.txt", header = F,
	stringsAsFactors = F)
colnames(gencode_gsymbol_id) <- c("id", "name")

pathway_ensemblid <- left_join(true.positive.list, gencode_gsymbol_id, by = c("V1" = "name"))
pathway_ensemblid <- left_join(pathway_ensemblid, gencode_gsymbol_id, by = c("V2" = "name"))
pathway_ensemblid <- pathway_ensemblid[which(!is.na(pathway_ensemblid$id.x) & !is.na(pathway_ensemblid$id.y)),]
p_ensemblid <- pathway_ensemblid[,c("id.x","id.y")]
p_ensemblid <- t(apply(p_ensemblid, 1, sort))
# p_ensemblid <- do.call(rbind, p_ensemblid)
p_ensemblid <- as.data.frame(p_ensemblid, stringsAsFactors = F)
p_ensemblid$edges <- paste(p_ensemblid[,1], p_ensemblid[,2], sep = "_")

cross_mapping_genes$V1 <- NULL
cross_mapping_genes <- cross_mapping_genes[which(cross_mapping_genes$V2 %in% gencode_gsymbol_id$id & cross_mapping_genes$V3 %in% gencode_gsymbol_id$id),]
dim(cross_mapping_genes)

cross_mapping_genes$edges <- paste(cross_mapping_genes[,1], cross_mapping_genes[,2], sep = "_")

cross_mapping_pathway_pairs <- intersect(p_ensemblid$edges, cross_mapping_genes$edges)
saveRDS(p_ensemblid, file = "/work-zfs/abattle4/parsana/networks_correction/results/canonical_pathways_ensembl_id.RDS")
saveRDS(cross_mapping_genes, file = "/work-zfs/abattle4/parsana/networks_correction/results/cross_mapping_protein_coding.RDS")


