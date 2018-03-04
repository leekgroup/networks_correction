load("/work-zfs/abattle4/parsana/networks_correction/publication_rmd/gene_gc_content/analysis/gc_estimate_sample.RData")
load("/work-zfs/abattle4/parsana/networks_correction/data/raw_subset.Rdata")

all(colnames(gtex.rse.sub$Subcutaneous)==names(gc.coeff$Subcutaneous))
all(colnames(gtex.rse.sub$Lung)==names(gc.coeff$Lung))
all(colnames(gtex.rse.sub$Thyroid)==names(gc.coeff$Thyroid))
all(colnames(gtex.rse.sub$Muscle)==names(gc.coeff$Muscle))
all(colnames(gtex.rse.sub$Blood)==names(gc.coeff$Blood))

gtex.rse.sub$Subcutaneous@colData$gc <- gc.coeff$Subcutaneous
gtex.rse.sub$Lung@colData$gc <- gc.coeff$Lung
gtex.rse.sub$Thyroid@colData$gc <- gc.coeff$Thyroid
gtex.rse.sub$Muscle@colData$gc <- gc.coeff$Muscle
gtex.rse.sub$Blood@colData$gc <- gc.coeff$Blood

save(gtex.rse.sub, file = "/work-zfs/abattle4/parsana/networks_correction/data/raw_subset_gc_attached.Rdata")
