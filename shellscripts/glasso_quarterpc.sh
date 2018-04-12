#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript infer_glasso.R $datDir/quarterpc_corrected.Rdata Subcutaneous $networksDir/quarterpc/Subcutaneous_glasso_networks.Rdata >$logDir/subcutaneous_quarterpc_glasso.log
Rscript infer_glasso.R $datDir/quarterpc_corrected.Rdata Lung $networksDir/quarterpc/Lung_glasso_networks.Rdata >$logDir/lung_quarterpc_glasso.log
Rscript infer_glasso.R $datDir/quarterpc_corrected.Rdata Thyroid $networksDir/quarterpc/Thyroid_glasso_networks.Rdata >$logDir/thyroid_quarterpc_glasso.log
Rscript infer_glasso.R $datDir/quarterpc_corrected.Rdata Muscle $networksDir/quarterpc/Muscle_glasso_networks.Rdata >$logDir/muscle_quarterpc_glasso.log
Rscript infer_glasso.R $datDir/quarterpc_corrected.Rdata Blood $networksDir/quarterpc/Blood_glasso_networks.Rdata >$logDir/blood_quarterpc_glasso.log
