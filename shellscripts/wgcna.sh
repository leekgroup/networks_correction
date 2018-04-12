#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=70G
#SBATCH --partition=shared

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

## WGCNA networks
mkdir $networksDir/raw/
mkdir $networksDir/rin/
mkdir $networksDir/gc/
mkdir $networksDir/pc/
mkdir $networksDir/halfpc/
mkdir $networksDir/quarterpc/
Rscript infer_wgcna.R $datDir/raw_subset.Rdata unsigned $networksDir/raw/wgcna_networks.Rdata >$logDir/raw_wgcna.log
Rscript infer_wgcna.R $datDir/rin_corrected.Rdata unsigned $networksDir/rin/wgcna_networks.Rdata >$logDir/rin_wgcna.log
Rscript infer_wgcna.R $datDir/gc_corrected.Rdata unsigned $networksDir/gc/wgcna_networks.Rdata >$logDir/gc_wgcna.log
Rscript infer_wgcna.R $datDir/pc_corrected.Rdata unsigned $networksDir/pc/wgcna_networks.Rdata >$logDir/pc_wgcna.log
Rscript infer_wgcna.R $datDir/half_pc_corrected.Rdata unsigned $networksDir/halfpc/wgcna_networks.Rdata >$logDir/halfpc_wgcna.log
Rscript infer_wgcna.R $datDir/quarter_pc_corrected.Rdata unsigned $networksDir/quarterpc/wgcna_networks.Rdata >$logDir/quarterpc_wgcna.log

## compute precision recall, make plots
mkdir $resultDir/PR/
mkdir $plotDir/PR/
mkdir $plotDir/density/
Rscript pr_wgcna.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_subcutaneous.log
Rscript pr_wgcna.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_lung.log
Rscript pr_wgcna.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_thyroid.log
Rscript pr_wgcna.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_muscle.log
Rscript pr_wgcna.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_blood.log
