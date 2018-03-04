#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=70G

source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrectsrc

#Rscript infer_networks_updated.R raw WGCNA >log/raw_wgcna.log 
Rscript infer_networks_updated.R raw glasso Thyroid >log/raw_thyroid.log 
Rscript infer_networks_updated.R raw glasso Subcutaneous >log/raw_sub.log 
Rscript infer_networks_updated.R raw glasso Lung >log/raw_lung.log
Rscript infer_networks_updated.R raw glasso Blood >log/raw_blood.log
Rscript infer_networks_updated.R raw glasso Muscle >log/raw_muscle.log
