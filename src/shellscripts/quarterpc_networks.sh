#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=80G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/src/
mkdir log

# quarter pc
#Rscript infer_networks_updated.R quarter WGCNA >log/quarter_wgcna.log
Rscript infer_networks_updated.R quarter glasso Thyroid >log/quarter_thyroid.log
Rscript infer_networks_updated.R quarter glasso Subcutaneous >log/quarter_sub.log
Rscript infer_networks_updated.R quarter glasso Lung >log/quarter_lung.log
Rscript infer_networks_updated.R quarter glasso Blood >log/quarter_blood.log
Rscript infer_networks_updated.R quarter glasso Muscle >log/quarter_muscle.log
