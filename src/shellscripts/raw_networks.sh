#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=70G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/src/
#Rscript infer_networks_updated.R raw WGCNA >log/raw_wgcna.log 
Rscript infer_networks_updated.R raw glasso Thyroid >log/raw_thyroid.log 
Rscript infer_networks_updated.R raw glasso Subcutaneous >log/raw_sub.log 
Rscript infer_networks_updated.R raw glasso Lung >log/raw_lung.log
Rscript infer_networks_updated.R raw glasso Blood >log/raw_blood.log
Rscript infer_networks_updated.R raw glasso Muscle >log/raw_muscle.log
