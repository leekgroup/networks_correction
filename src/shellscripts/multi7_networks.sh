#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=80G

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrectsrc

mkdir log

### multiple 3 cov
Rscript infer_networks_updated.R multi7 WGCNA >log/multi7_wgcna.log
#Rscript infer_networks_updated.R multi7 glasso Thyroid >log/multi7_thyroid.log
#Rscript infer_networks_updated.R multi7 glasso Subcutaneous >log/multi7_sub.log
#Rscript infer_networks_updated.R multi7 glasso Lung >log/multi7_lung.log
#Rscript infer_networks_updated.R multi7 glasso Blood >log/multi7_blood.log
#Rscript infer_networks_updated.R multi7 glasso Muscle >log/multi7_muscle.log
