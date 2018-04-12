#!/bin/sh
#SBATCH --time=6:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript pr_corrnet.R Subcutaneous "seq(0.0,0.9,length.out = 50)" $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_corrnet_subcutaneous.log
Rscript pr_corrnet.R Lung "seq(0.0,0.9,length.out = 50)" $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_corrnet_lung.log
Rscript pr_corrnet.R Thyroid "seq(0.0,0.9,length.out = 50)" $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_corrnet_thyroid.log
Rscript pr_corrnet.R Muscle "seq(0.0,0.9,length.out = 50)" $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_corrnet_muscle.log
Rscript pr_corrnet.R Blood "seq(0.0,0.9,length.out = 50)" $datDir/genesets/canonical_pathways_merged.txt $plotDir $resultDir >$logDir/pr_corrnet_blood.log
