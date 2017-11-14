#!/bin/sh
#SBATCH --time=100:0:0
#SBATCH --mem=80G

cd /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/src/
mkdir log


## gc_residuals
Rscript infer_networks_updated.R gc WGCNA >log/gc_wgcna.log
Rscript infer_networks_updated.R gc glasso Thyroid >log/gc_thyroid.log 
Rscript infer_networks_updated.R gc glasso Subcutaneous >log/gc_sub.log
Rscript infer_networks_updated.R gc glasso Lung >log/gc_lung.log
Rscript infer_networks_updated.R gc glasso Blood >log/gc_blood.log
Rscript infer_networks_updated.R gc glasso Muscle >log/gc_muscle.log
