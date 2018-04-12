#!/bin/sh

#SBATCH --time=96:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

mkdir $networksDir/exnoicRate
cd $scriptDir

Rscript infer_glasso.R $datDir/exonicRate_corrected.Rdata Subcutaneous $networksDir/exnoicRate/Subcutaneous_glasso_networks.Rdata >$logDir/subcutaneous_exnoicRate_glasso.log
Rscript infer_glasso.R $datDir/exonicRate_corrected.Rdata Lung $networksDir/exnoicRate/Lung_glasso_networks.Rdata >$logDir/lung_exnoicRate_glasso.log
Rscript infer_glasso.R $datDir/exonicRate_corrected.Rdata Thyroid $networksDir/exnoicRate/Thyroid_glasso_networks.Rdata >$logDir/thyroid_exnoicRate_glasso.log
Rscript infer_glasso.R $datDir/exonicRate_corrected.Rdata Muscle $networksDir/exnoicRate/Muscle_glasso_networks.Rdata >$logDir/muscle_exnoicRate_glasso.log
Rscript infer_glasso.R $datDir/exonicRate_corrected.Rdata Blood $networksDir/exnoicRate/Blood_glasso_networks.Rdata >$logDir/blood_exnoicRate_glasso.log
