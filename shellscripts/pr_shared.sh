#!/bin/sh
#SBATCH --time=46:0:0
#SBATCH --mem=80G
#SBATCH --partition=shared

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir


Rscript compute_pr.R Subcutaneous $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_subcutaneous wgcna-signed TRUE >$logDir/pr_shared_wgcna-signed_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_lung wgcna-signed TRUE >$logDir/pr_shared_wgcna-signed_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_thyroid wgcna-signed TRUE >$logDir/pr_shared_wgcna-signed_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_muscle wgcna-signed TRUE >$logDir/pr_shared_wgcna-signed_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_blood wgcna-signed TRUE >$logDir/pr_shared_wgcna-signed_blood.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_artery wgcna-signed TRUE >$logDir/pr_shared_pathways_merged_wgcna-signed_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_nerve wgcna-signed TRUE >$logDir/pr_shared_pathways_merged_wgcna-signed_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_skin wgcna-signed TRUE >$logDir/pr_shared_pathways_merged_wgcna-signed_skin.log


Rscript compute_pr.R Subcutaneous $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_subcutaneous glasso TRUE >$logDir/pr_shared_glasso_subcutaneous.log
Rscript compute_pr.R Lung $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_lung glasso TRUE >$logDir/pr_shared_glasso_lung.log
Rscript compute_pr.R Thyroid $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_thyroid glasso TRUE >$logDir/pr_shared_glasso_thyroid.log
Rscript compute_pr.R Muscle $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_muscle glasso TRUE >$logDir/pr_shared_glasso_muscle.log
Rscript compute_pr.R Blood $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_blood glasso TRUE >$logDir/pr_shared_glasso_blood.log
od.log
Rscript compute_pr.R Artery_tibial $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_artery glasso TRUE >$logDir/pr_shared_glasso_srtery.log
Rscript compute_pr.R Nerve_tibial $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_nerve glasso TRUE >$logDir/pr_shared_glasso_nerve.log
Rscript compute_pr.R Skin $datDir/genesets/edges_in_twopathways.txt $plotDir $resultDir shared_skin glasso TRUE >$logDir/pr_shared_glasso_skin.log


