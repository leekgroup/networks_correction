#!/bin/sh
#SBATCH --time=6:0:0
#SBATCH --mem=80G
#SBATCH --partition=lrgmem

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript pr_wgcna.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_wgcna_subcutaneous.log
Rscript pr_wgcna.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_wgcna_lung.log
Rscript pr_wgcna.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_wgcna_thyroid.log
Rscript pr_wgcna.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_wgcna_muscle.log
Rscript pr_wgcna.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_wgcna_blood.log
