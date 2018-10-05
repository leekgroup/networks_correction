#!/bin/sh
#SBATCH --time=72:0:0
#SBATCH --mem=70G
#SBATCH --partition=lrgmem

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

## WGCNA networks
mkdir $networksDir/raw/
mkdir $networksDir/rin/
mkdir $networksDir/gc/
mkdir $networksDir/pc/
mkdir $networksDir/halfpc/
mkdir $networksDir/quarterpc/
mkdir $networksDir/mc/
mkdir $networksDir/exonicRate/

Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/raw_subset.Rdata unsigned $networksDir/raw/wgcna_networks.Rdata >$logDir/raw_wgcna.log 2>&1 
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/rin_corrected.Rdata unsigned $networksDir/rin/wgcna_networks.Rdata >$logDir/rin_wgcna.log 2>&1 
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/gc_corrected.Rdata unsigned $networksDir/gc/wgcna_networks.Rdata >$logDir/gc_wgcna.log 2>&1 
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/mc_corrected.Rdata unsigned $networksDir/mc/wgcna_networks.Rdata >$logDir/mc_wgcna.log 2>&1 
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/exonicRate_corrected.Rdata unsigned $networksDir/exonicRate/wgcna_networks.Rdata >$logDir/exonicRate_wgcna.log 2>&1 
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/pc_corrected.Rdata unsigned $networksDir/pc/wgcna_networks.Rdata >$logDir/pc_wgcna.log 2>&1 
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/halfpc_corrected.Rdata unsigned $networksDir/halfpc/wgcna_networks.Rdata >$logDir/halfpc_wgcna.log 2>&1 
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/quarterpc_corrected.Rdata unsigned $networksDir/quarterpc/wgcna_networks.Rdata >$logDir/quarterpc_wgcna.log 2>&1 

## compute precision recall, make plots
mkdir $resultDir/PR/
mkdir $plotDir/PR/
mkdir $plotDir/density/
Rscript --no-save --no-restore --verbose pr_wgcna.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_subcutaneous.log 2>&1 
Rscript --no-save --no-restore --verbose pr_wgcna.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_lung.log 2>&1
Rscript --no-save --no-restore --verbose pr_wgcna.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_thyroid.log 2>&1
Rscript --no-save --no-restore --verbose pr_wgcna.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_muscle.log 2>&1
Rscript --no-save --no-restore --verbose pr_wgcna.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_blood.log 2>&1
