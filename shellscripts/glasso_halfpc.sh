#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript infer_glasso.R $datDir/halfpc_corrected.Rdata Subcutaneous $networksDir/halfpc/Subcutaneous_glasso_networks.Rdata >$logDir/subcutaneous_halfpc_glasso.log
Rscript infer_glasso.R $datDir/halfpc_corrected.Rdata Lung $networksDir/halfpc/Lung_glasso_networks.Rdata >$logDir/lung_halfpc_glasso.log
Rscript infer_glasso.R $datDir/halfpc_corrected.Rdata Thyroid $networksDir/halfpc/Thyroid_glasso_networks.Rdata >$logDir/thyroid_halfpc_glasso.log
Rscript infer_glasso.R $datDir/halfpc_corrected.Rdata Muscle $networksDir/halfpc/Muscle_glasso_networks.Rdata >$logDir/muscle_halfpc_glasso.log
Rscript infer_glasso.R $datDir/halfpc_corrected.Rdata Blood $networksDir/halfpc/Blood_glasso_networks.Rdata >$logDir/blood_halfpc_glasso.log
