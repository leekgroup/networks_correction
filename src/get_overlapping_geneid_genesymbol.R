rm(list = ls())
library(GenomicFeatures)
library(GenomicRanges)
library(dplyr)
d = read.delim("/work-zfs/abattle4/parsana/networks_correction/data/etc/gencode_exon_utr_position_bygene.txt", header = F, stringsAsFactors = F)

colnames(d) <- c("chr", "reg", "start", "stop", "strand", "id", "gene_name")
d$id <- gsub("\\ ", "", d$id)
d$strand <- NULL
head(d)
d_gr = makeGRangesFromDataFrame(d, seqnames.field = "chr",keep.extra.columns = T)

# d_r = reduce(d_gr)
type2 = findOverlaps(d_gr, d_gr, type = "any")
type2.df = data.frame(d_gr[queryHits(type2),], d_gr[subjectHits(type2),])
head(type2.df)
k <- which(type2.df$id == type2.df$id.1)
type2.df <- type2.df[-k,]
ensembl_pairs_overlapping <- unique(t(apply(type2.df[,c("id","id.1")], 1, sort)))
ensembl_with_some_overlap = unique(c(ensembl_pairs_overlapping[,1],ensembl_pairs_overlapping[,2]))
write.table(ensembl_with_some_overlap, file = "/work-zfs/abattle4/parsana/networks_correction/data/etc/ensembl_ids_overlapping_genes.txt", quote = F, row.names = F)
gsymbol_pairs_overlapping <- unique(t(apply(type2.df[,c("gene_name","gene_name.1")], 1, sort)))
gsymbol_with_some_overlap = unique(c(gsymbol_pairs_overlapping[,1],gsymbol_pairs_overlapping[,2]))
write.table(gsymbol_with_some_overlap, file = "/work-zfs/abattle4/parsana/networks_correction/data/etc/gene_symbol_overlapping_genes.txt", quote = F, row.names = F)
# length(genes_with_some_overlap)


