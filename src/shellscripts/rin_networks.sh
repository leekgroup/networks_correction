#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=80G

cd /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/src/
mkdir log


## RIN
#Rscript infer_networks_updated.R rin WGCNA >log/rin_wgcna.log
Rscript infer_networks_updated.R rin glasso Thyroid >log/rin_thyroid.log 
Rscript infer_networks_updated.R rin glasso Subcutaneous >log/rin_sub.log
Rscript infer_networks_updated.R rin glasso Lung >log/rin_lung.log
Rscript infer_networks_updated.R rin glasso Blood >log/rin_blood.log
Rscript infer_networks_updated.R rin glasso Muscle >log/rin_muscle.log
