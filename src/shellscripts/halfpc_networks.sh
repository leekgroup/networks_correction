#!/bin/sh
#SBATCH --time=60:0:0
#SBATCH --mem=80G

source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrectsrc

mkdir log

# half-pc
#Rscript infer_networks_updated.R halfpc WGCNA >log/halfpc_wgcna.log
Rscript infer_networks_updated.R halfpc glasso Thyroid >log/halfpc_thyroid.log
Rscript infer_networks_updated.R halfpc glasso Subcutaneous >log/halfpc_sub.log
Rscript infer_networks_updated.R halfpc glasso Lung >log/halfpc_lung.log
Rscript infer_networks_updated.R halfpc glasso Blood >log/halfpc_blood.log
Rscript infer_networks_updated.R halfpc glasso Muscle >log/halfpc_muscle.log
