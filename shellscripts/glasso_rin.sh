#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript infer_glasso.R $datDir/rin_corrected.Rdata Subcutaneous $networksDir/rin/Subcutaneous_glasso_networks.Rdata >$logDir/subcutaneous_rin_glasso.log
Rscript infer_glasso.R $datDir/rin_corrected.Rdata Lung $networksDir/rin/Lung_glasso_networks.Rdata >$logDir/lung_rin_glasso.log
Rscript infer_glasso.R $datDir/rin_corrected.Rdata Thyroid $networksDir/rin/Thyroid_glasso_networks.Rdata >$logDir/thyroid_rin_glasso.log
Rscript infer_glasso.R $datDir/rin_corrected.Rdata Muscle $networksDir/rin/Muscle_glasso_networks.Rdata >$logDir/muscle_rin_glasso.log
Rscript infer_glasso.R $datDir/rin_corrected.Rdata Blood $networksDir/rin/BZZlood_glasso_networks.Rdata >$logDir/blood_rin_glasso.log
