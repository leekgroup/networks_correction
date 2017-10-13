#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=80G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/src/
mkdir log

## pc
#Rscript infer_networks_updated.R pc WGCNA >log/pc_wgcna.log
Rscript infer_networks_updated.R pc glasso Thyroid >log/pc_thyroid.log
Rscript infer_networks_updated.R pc glasso Subcutaneous >log/pc_sub.log
Rscript infer_networks_updated.R pc glasso Lung >log/pc_lung.log
Rscript infer_networks_updated.R pc glasso Muscle >log/pc_muscle.log
Rscript infer_networks_updated.R pc glasso Blood >log/pc_blood.log
