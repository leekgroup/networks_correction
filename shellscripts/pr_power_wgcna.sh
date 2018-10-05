#!/bin/sh
#SBATCH --time=26:0:0
#SBATCH --mem=80G
#SBATCH --partition=shared

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

Rscript compute_pr.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_subcutaneous power_wgcna FALSE >$logDir/pr_canonical_power_wgcna_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_lung power_wgcna FALSE >$logDir/pr_canonical_power_wgcna_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_thyroid power_wgcna FALSE >$logDir/pr_canonical_power_wgcna_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_muscle power_wgcna FALSE >$logDir/pr_canonical_power_wgcna_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_blood power_wgcna FALSE >$logDir/pr_canonical_power_wgcna_blood.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_artery power_wgcna FALSE >$logDir/pr_canonical_pathways_merged_power_wgcna_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_nerve power_wgcna FALSE >$logDir/pr_canonical_pathways_merged_power_wgcna_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_skin power_wgcna FALSE >$logDir/pr_canonical_pathways_merged_power_wgcna_skin.log


Rscript compute_pr.R Subcutaneous $datDir/genesets/tft.txt $plotDir $resultDir tft_subcutaneous power_wgcna FALSE >$logDir/pr_tft_power_wgcna_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/tft.txt $plotDir $resultDir tft_lung power_wgcna FALSE >$logDir/pr_tft_power_wgcna_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/tft.txt $plotDir $resultDir tft_thyroid power_wgcna FALSE >$logDir/pr_tft_power_wgcna_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/tft.txt $plotDir $resultDir tft_muscle power_wgcna FALSE >$logDir/pr_tft_power_wgcna_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/tft.txt $plotDir $resultDir tft_blood power_wgcna FALSE >$logDir/pr_tft_power_wgcna_blood.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/tft.txt $plotDir $resultDir tft_artery power_wgcna FALSE >$logDir/pr_tft_power_wgcna_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/tft.txt $plotDir $resultDir tft_nerve power_wgcna FALSE >$logDir/pr_tft_power_wgcna_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/tft.txt $plotDir $resultDir tft_skin power_wgcna FALSE >$logDir/pr_tft_power_wgcna_skin.log
