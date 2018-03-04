#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=80G

source ~/.bash_profile
cd $parsana/networks_correction/src/
mkdir log


### multiple 3 cov
Rscript infer_networks_updated.R multi3 WGCNA >log/multi3_wgcna.log
Rscript infer_networks_updated.R multi3 glasso Thyroid >log/multi3_thyroid.log
Rscript infer_networks_updated.R multi3 glasso Subcutaneous >log/multi3_sub.log
Rscript infer_networks_updated.R multi3 glasso Lung >log/multi3_lung.log
Rscript infer_networks_updated.R multi3 glasso Blood >log/multi3_blood.log
Rscript infer_networks_updated.R multi3 glasso Muscle >log/multi3_muscle.log
