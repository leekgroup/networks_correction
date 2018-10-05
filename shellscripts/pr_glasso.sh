#!/bin/sh
#SBATCH --time=24:0:0
#SBATCH --mem=80G
#SBATCH --partition=shared

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

Rscript compute_pr.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_subcutaneous glasso FALSE >$logDir/pr_canonical_glasso_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_lung glasso FALSE >$logDir/pr_canonical_glasso_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_thyroid glasso FALSE >$logDir/pr_canonical_glasso_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_muscle glasso FALSE >$logDir/pr_canonical_glasso_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_blood glasso FALSE >$logDir/pr_canonical_glasso_blood.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_artery glasso FALSE >$logDir/pr_canonical_glasso_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_nerve glasso FALSE >$logDir/pr_canonical_glasso_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_skin glasso FALSE >$logDir/pr_canonical_glasso_skin.log

#Rscript compute_pr.R Subcutaneous $datDir/genesets/tft.txt $plotDir $resultDir tft_subcutaneous glasso FALSE >$logDir/pr_tft_glasso_subcutaneous.log
#Rscript compute_pr.R Lung $datDir/genesets/tft.txt $plotDir $resultDir tft_lung glasso FALSE >$logDir/pr_tft_glasso_lung.log
#Rscript compute_pr.R Thyroid $datDir/genesets/tft.txt $plotDir $resultDir tft_thyroid glasso FALSE >$logDir/pr_tft_glasso_thyroid.log
#Rscript compute_pr.R Muscle $datDir/genesets/tft.txt $plotDir $resultDir tft_muscle glasso FALSE >$logDir/pr_tft_glasso_muscle.log
#Rscript compute_pr.R Artery_tibial $datDir/genesets/tft.txt $plotDir $resultDir tft_artery glasso FALSE >$logDir/pr_tft_glasso_srtery.log
#Rscript compute_pr.R Nerve_tibial $datDir/genesets/tft.txt $plotDir $resultDir tft_nerve glasso FALSE >$logDir/pr_tft_glasso_nerve.log
#Rscript compute_pr.R Skin $datDir/genesets/tft.txt $plotDir $resultDir tft_skin glasso FALSE >$logDir/pr_tft_glasso_skin.log
#Rscript compute_pr.R Blood $datDir/genesets/tft.txt $plotDir $resultDir tft_blood glasso FALSE >$logDir/pr_tft_glasso_blood.log
