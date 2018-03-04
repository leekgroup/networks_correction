#!/bin/sh
#SBATCH --account=kpienta1
#SBATCH --time=12:0:0
#SBATCH --mem=80G

cd $parsana/networks_correction/src/
mkdir log


## exon
#Rscript infer_networks_updated.R exon WGCNA >log/exon_wgcna.log
#Rscript infer_networks_updated.R exon glasso Thyroid >log/exon_thyroid.log 
#Rscript infer_networks_updated.R exon glasso Subcutaneous >log/exon_sub.log
#Rscript infer_networks_updated.R exon glasso Lung >log/exon_lung.log
#Rscript infer_networks_updated.R exon glasso Blood >log/exon_blood.log
Rscript infer_networks_updated.R exon glasso Muscle >log/exon_muscle.log
