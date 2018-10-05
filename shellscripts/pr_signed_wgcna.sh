#!/bin/sh
#SBATCH --time=26:0:0
#SBATCH --mem=80G
#SBATCH --partition=shared

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

Rscript compute_pr.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_subcutaneous wgcna-signed FALSE >$logDir/pr_canonical_wgcna-signed_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_lung wgcna-signed FALSE >$logDir/pr_canonical_wgcna-signed_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_thyroid wgcna-signed FALSE >$logDir/pr_canonical_wgcna-signed_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_muscle wgcna-signed FALSE >$logDir/pr_canonical_wgcna-signed_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_blood wgcna-signed FALSE >$logDir/pr_canonical_wgcna-signed_blood.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_artery wgcna-signed FALSE >$logDir/pr_canonical_pathways_merged_wgcna-signed_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_nerve wgcna-signed FALSE >$logDir/pr_canonical_pathways_merged_wgcna-signed_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_skin wgcna-signed FALSE >$logDir/pr_canonical_pathways_merged_wgcna-signed_skin.log


Rscript compute_pr.R Subcutaneous $datDir/genesets/tft.txt $plotDir $resultDir tft_subcutaneous wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/tft.txt $plotDir $resultDir tft_lung wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/tft.txt $plotDir $resultDir tft_thyroid wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/tft.txt $plotDir $resultDir tft_muscle wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/tft.txt $plotDir $resultDir tft_blood wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_blood.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/tft.txt $plotDir $resultDir tft_artery wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/tft.txt $plotDir $resultDir tft_nerve wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/tft.txt $plotDir $resultDir tft_skin wgcna-signed FALSE >$logDir/pr_tft_wgcna-signed_skin.log
