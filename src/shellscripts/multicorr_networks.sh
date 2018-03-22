#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=80G

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrectsrc

mkdir log

### multiple covariates regression
Rscript infer_networks_updated.R multicorr WGCNA >log/multicorr_wgcna.log
Rscript infer_networks_updated.R multicorr glasso Thyroid >log/multicorr_thyroid.log
Rscript infer_networks_updated.R multicorr glasso Subcutaneous >log/multicorr_sub.log
Rscript infer_networks_updated.R multicorr glasso Lung >log/multicorr_lung.log
Rscript infer_networks_updated.R multicorr glasso Blood >log/multicorr_blood.log
Rscript infer_networks_updated.R multicorr glasso Muscle >log/multicorr_muscle.log
