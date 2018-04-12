#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=70G

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

# get the list of true positives
./get_true_positive.sh >$logDir/tp.log

#compute gene specific GC content
python compute_gc.py $datDir/etc/gencode.v25.pc_transcripts.fa $datDir/etc/gene_full_gc_content.txt

cd $scriptDir
Rscript dataDownload.R >$logDir/download.log
Rscript compute_gc_estimates.R $datDir/raw_protein_coding.Rdata $datDir/etc/gene_full_gc_content.txt $datDir/raw_protein_coding_withGC.Rdata >$logDir/compute_gc_estimates.log
Rscript select_genes.R $datDir/raw_protein_coding_withGC.Rdata 5000 $datDir/etc/variable_genes_selected.csv $datDir/raw_subset.Rdata >$logDir/select_genes.log

## Single covariate correction
Rscript single_covariate_correction.R $datDir/raw_subset.Rdata smrin $datDir/rin_corrected.Rdata >$logDir/rin_correction.log
Rscript single_covariate_correction.R $datDir/raw_subset.Rdata smexncrt $datDir/exonicRate_corrected.Rdata >$logDir/exonicRate_correction.log
Rscript single_covariate_correction.R $datDir/raw_subset.Rdata gc $datDir/gc_corrected.Rdata >$logDir/gc_correction.log

## Multiple covariate correction
 # Compute expression pve by known covariates
Rscript known_covariates_expression_pve.R $datDir/raw_protein_coding_withGC.Rdata $plotDir $resultDir >$logDir/known_covariates_expression_pve.log
Rscript multiple_covariate_correction.R $datDir/raw_subset.Rdata $resultDir/tissue_pve.Rds $datDir/mc_corrected.Rdata >$logDir/mc_correction.log
 # TO Do

## PC correction
Rscript pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/etc/variable_genes_selected.csv TRUE $datDir/pc_corrected.Rdata >$logDir/allpc_correction.log
Rscript pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/etc/variable_genes_selected.csv FALSE $datDir/halfpc_corrected.Rdata "c(19, 15, 19, 20, 13)" $datDir/pc_loadings.Rdata >$logDir/halfpc_correction.log
Rscript pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/etc/variable_genes_selected.csv FALSE $datDir/quarterpc_corrected.Rdata "c(9, 8, 10, 10, 6)" $datDir/pc_loadings.Rdata >$logDir/quarterpc_correction.log

## WGCNA networks
mkdir $networksDir/raw/
mkdir $networksDir/rin/
mkdir $networksDir/gc/
mkdir $networksDir/pc/
mkdir $networksDir/halfpc/
mkdir $networksDir/quarterpc/
mkdir $networksDir/exonicRate/

cd $homeDir/shellscripts/
sbatch wgcna.sh


## Untransformed unsigned pairwise correlation networks
cd $homeDir/shellscripts/

sbatch corrnet.sh


## Graphical Lasso
cd $homeDir/shellscripts/
./submit_jobs_glasso.sh
