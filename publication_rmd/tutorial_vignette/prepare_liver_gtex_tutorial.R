
load(url("http://duffel.rail.bio/recount/v2/SRP012682/rse_gene_liver.Rdata"))
rse <- scale_counts(rse_gene)
rse_raw <- log2(rse@assays$data$counts+2)
genes_var <- apply(rse_raw, 1, var)
select_genes <- names(genes_var)[order(genes_var, decreasing = T)][1:1000]
rse_raw <- rse_raw[select_genes,]
save(rse_raw, file = "liver_subset_gtex.Rdata")