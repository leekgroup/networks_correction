#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript infer_glasso.R $datDir/pc_corrected.Rdata Subcutaneous $networksDir/pc/Subcutaneous_glasso_networks.Rdata >$logDir/subcutaneous_pc_glasso.log
Rscript infer_glasso.R $datDir/pc_corrected.Rdata Lung $networksDir/pc/Lung_glasso_networks.Rdata >$logDir/lung_pc_glasso.log
Rscript infer_glasso.R $datDir/pc_corrected.Rdata Thyroid $networksDir/pc/Thyroid_glasso_networks.Rdata >$logDir/thyroid_pc_glasso.log
Rscript infer_glasso.R $datDir/pc_corrected.Rdata Muscle $networksDir/pc/Muscle_glasso_networks.Rdata >$logDir/muscle_pc_glasso.log
Rscript infer_glasso.R $datDir/pc_corrected.Rdata Blood $networksDir/pc/Blood_glasso_networks.Rdata >$logDir/blood_pc_glasso.log
