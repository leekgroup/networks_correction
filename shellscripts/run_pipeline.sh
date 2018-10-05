#!/bin/sh

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

# get the list of true positives
./get_true_positive.sh >$logDir/tp.log 2>&1
Rscript $scriptDir/get_overlapping_geneid_genesymbol.R >$logDir/get_overlapping_genes.log 2>&1
#compute gene specific GC content
echo "now computing gene GC"
python $scriptDir/compute_gene_GC.py $datDir/etc/gencode.v25.pc_transcripts.fa $datDir/etc/gene_full_gc_content.txt

cd $scriptDir
Rscript --no-save --no-restore --verbose get_shared_pathway_edges.R >$logDir/shared_pathway_edges.log 2>&1
Rscript --no-save --no-restore --verbose dataDownload.R >$logDir/download.log 2>&1
Rscript --no-save --no-restore --verbose compute_gc_estimates.R $datDir/raw_protein_coding.Rdata $datDir/etc/gene_full_gc_content.txt $datDir/raw_protein_coding_withGC.Rdata >$logDir/compute_gc_estimates.log 2>&1
Rscript --no-save --no-restore --verbose select_genes.R $datDir/raw_protein_coding_withGC.Rdata 5000 $datDir/raw_subset.Rdata $datDir/raw_subset.Rdata >$logDir/select_genes.log 2>&1

## Single covariate correction
Rscript --no-save --no-restore --verbose single_covariate_correction.R $datDir/raw_subset.Rdata smrin $datDir/rin_corrected.Rdata >$logDir/rin_correction.log 2>&1
Rscript --no-save --no-restore --verbose single_covariate_correction.R $datDir/raw_subset.Rdata smexncrt $datDir/exonicRate_corrected.Rdata >$logDir/exonicRate_correction.log 2>&1
Rscript --no-save --no-restore --verbose single_covariate_correction.R $datDir/raw_subset.Rdata gc $datDir/gc_corrected.Rdata >$logDir/gc_correction.log 2>&1

## Multiple covariate correction
 # Compute expression pve by known covariates
Rscript --no-save --no-restore --verbose known_covariates_expression_pve.R $datDir/raw_protein_coding_withGC.Rdata $plotDir $resultDir >$logDir/known_covariates_expression_pve.log 2>&1
Rscript --no-save --no-restore --verbose multiple_covariate_correction.R $datDir/raw_subset.Rdata $resultDir/tissue_pve.Rds $datDir/mc_corrected.Rdata >$logDir/mc_correction.log 2>&1


## PC correction
Rscript --no-save --no-restore --verbose pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/raw_subset.Rdata TRUE $datDir/pc_corrected.Rdata >$logDir/allpc_correction.log 2>&1
Rscript --no-save --no-restore --verbose pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/raw_subset.Rdata FALSE $datDir/halfpc_corrected.Rdata "c(19, 15, 18, 18, 12, 16, 16, 16)" $datDir/pc_loadings.Rdata >$logDir/halfpc_correction.log 2>&1
Rscript --no-save --no-restore --verbose pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/raw_subset.Rdata FALSE $datDir/quarterpc_corrected.Rdata "c(9, 7, 9, 9, 6, 8, 8, 8)" $datDir/pc_loadings.Rdata >$logDir/quarterpc_correction.log 2>&1

## WGCNA networks
mkdir $networksDir/raw/
mkdir $networksDir/rin/
mkdir $networksDir/gc/
mkdir $networksDir/pc/
mkdir $networksDir/halfpc/
mkdir $networksDir/quarterpc/
mkdir $networksDir/exonicRate/
mkdir $networksDir/mc/

cd $homeDir/shellscripts/
#sbatch wgcna.sh
sbatch signed_wgcna.sh

## Untransformed unsigned pairwise correlation networks
cd $homeDir/shellscripts/

sbatch corrnet.sh


## Graphical Lasso
cd $homeDir/shellscripts/
./submit_jobs_glasso.sh

## WGCNA enrichments
#mkdir $resultDir/enrichment/
#sbatch wgcna_enrichment.sh

## compute precision and recall
#sbatch pr_wgcna.sh
#sbatch pr_glasso.sh
#sbatch pr_signed_wgcna.sh
