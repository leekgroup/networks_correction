#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=80G
#SBATCH --partition=shared

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

Rscript compute_pr.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_subcutaneous wgcna FALSE >$logDir/compute_pr_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_lung wgcna FALSE >$logDir/compute_pr_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_thyroid wgcna FALSE >$logDir/compute_pr_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_muscle wgcna FALSE >$logDir/compute_pr_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_blood wgcna FALSE >$logDir/compute_pr_blood.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_artery wgcna FALSE >$logDir/pr_canonical_pathways_merged_wgcna_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_nerve wgcna FALSE >$logDir/pr_canonical_pathways_merged_wgcna_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir canonical_skin wgcna FALSE >$logDir/pr_canonical_pathways_merged_wgcna_skin.log
