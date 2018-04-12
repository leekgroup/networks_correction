#!/bin/sh
#SBATCH --time=6:0:0
#SBATCH --mem=80G
#SBATCH --partition=lrgmem

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript pr_glasso.R Subcutaneous $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_glasso_subcutaneous.log
Rscript pr_glasso.R Lung $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_glasso_lung.log
Rscript pr_glasso.R Thyroid $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_glasso_thyroid.log
Rscript pr_glasso.R Muscle $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_glasso_muscle.log
Rscript pr_glasso.R Blood $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_glasso_blood.log

