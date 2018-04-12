#!/bin/sh
#SBATCH --time=120:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

## Graphical Lasso

Rscript infer_glasso.R $datDir/raw_subset.Rdata Subcutaneous $networksDir/raw/Subcutaneous_glasso_networks.Rdata >$logDir/subcutaneous_raw_glasso.log
Rscript infer_glasso.R $datDir/raw_subset.Rdata Lung $networksDir/raw/Lung_glasso_networks.Rdata >$logDir/lung_raw_glasso.log
Rscript infer_glasso.R $datDir/raw_subset.Rdata Thyroid $networksDir/raw/Thyroid_glasso_networks.Rdata >$logDir/thyroid_raw_glasso.log
Rscript infer_glasso.R $datDir/raw_subset.Rdata Muscle $networksDir/raw/Muscle_glasso_networks.Rdata >$logDir/muscle_raw_glasso.log
Rscript infer_glasso.R $datDir/raw_subset.Rdata Blood $networksDir/raw/Blood_glasso_networks.Rdata >$logDir/blood_raw_glasso.log

