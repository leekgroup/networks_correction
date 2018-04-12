#!/bin/sh

#SBATCH --time=96:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript infer_glasso.R $datDir/gc_corrected.Rdata Subcutaneous $networksDir/gc/Subcutaneous_glasso_networks.Rdata >$logDir/subcutaneous_gc_glasso.log
Rscript infer_glasso.R $datDir/gc_corrected.Rdata Lung $networksDir/gc/Lung_glasso_networks.Rdata >$logDir/lung_gc_glasso.log
Rscript infer_glasso.R $datDir/gc_corrected.Rdata Thyroid $networksDir/gc/Thyroid_glasso_networks.Rdata >$logDir/thyroid_gc_glasso.log
Rscript infer_glasso.R $datDir/gc_corrected.Rdata Muscle $networksDir/gc/Muscle_glasso_networks.Rdata >$logDir/muscle_gc_glasso.log
Rscript infer_glasso.R $datDir/gc_corrected.Rdata Blood $networksDir/gc/Blood_glasso_networks.Rdata >$logDir/blood_gc_glasso.log
