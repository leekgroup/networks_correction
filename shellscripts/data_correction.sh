#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=70G
#SBATCH --partition=lrgmem

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

## Single covariate correction
Rscript single_covariate_correction.R $datDir/raw_subset.Rdata smrin $datDir/rin_corrected.Rdata >$logDir/rin_correction.log
Rscript single_covariate_correction.R $datDir/raw_subset.Rdata smexncrt $datDir/exonicRate_corrected.Rdata >$logDir/exonicRate_correction.log
Rscript single_covariate_correction.R $datDir/raw_subset.Rdata gc $datDir/gc_corrected.Rdata >$logDir/gc_correction.log

## Multiple covariate correction
 # TO Do

## PC correction
Rscript pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/etc/variable_genes_selected.csv TRUE $datDir/pc_corrected.Rdata >$logDir/allpc_correction.log
Rscript pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/etc/variable_genes_selected.csv FALSE $datDir/half_pc_corrected.Rdata "c(19, 15, 19, 20, 13)" $datDir/pc_loadings.Rdata >$logDir/halfpc_correction.log
Rscript pc_correction.R $datDir/raw_protein_coding_withGC.Rdata $datDir/etc/variable_genes_selected.csv FALSE $datDir/quarter_pc_corrected.Rdata "c(9, 8, 10, 10, 6)" $datDir/pc_loadings.Rdata >$logDir/quarterpc_correction.log



