#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=70G

cd /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/src/
mkdir log
mkdir /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/plots/
#sh get_true_positive.sh >log/tp.log
Rscript dataDownload.R >log/download.log
Rscript process_gtex.R >log/process.log

cd /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/src/
Rscript infer_networks_updated.R raw WGCNA >log/raw_wgcna.log 
Rscript infer_networks_updated.R raw glasso Thyroid >log/raw_thyroid.log 
Rscript infer_networks_updated.R raw glasso Subcutaneous >log/raw_sub.log 
Rscript infer_networks_updated.R raw glasso Lung >log/raw_lung.log
Rscript infer_networks_updated.R raw glasso Blood >log/raw_blood.log
Rscript infer_networks_updated.R raw glasso Muscle >log/raw_muscle.log

### RIN
Rscript infer_networks_updated.R rin WGCNA >log/rin_wgcna.log
Rscript infer_networks_updated.R rin glasso Thyroid >log/rin_thyroid.log 
Rscript infer_networks_updated.R rin glasso Subcutaneous >log/rin_sub.log
Rscript infer_networks_updated.R rin glasso Lung >log/rin_lung.log
Rscript infer_networks_updated.R rin glasso Blood >log/rin_blood.log
Rscript infer_networks_updated.R rin glasso Muscle >log/rin_muscle.log

### exonic
Rscript infer_networks_updated.R exon WGCNA >log/exon_wgcna.log
Rscript infer_networks_updated.R exon glasso Thyroid >log/exon_thyroid.log
Rscript infer_networks_updated.R exon glasso Subcutaneous >log/exon_sub.log
Rscript infer_networks_updated.R exon glasso Lung >log/exon_lung.log
Rscript infer_networks_updated.R exon glasso Blood >log/exon_blood.log
Rscript infer_networks_updated.R exon glasso Muscle >log/exon_muscle.log

### expeff
Rscript infer_networks_updated.R expeff WGCNA >log/expeff_wgcna.log
Rscript infer_networks_updated.R expeff glasso Thyroid >log/expeff_thyroid.log
Rscript infer_networks_updated.R expeff glasso Subcutaneous >log/expeff_sub.log
Rscript infer_networks_updated.R expeff glasso Lung >log/expeff_lung.log
Rscript infer_networks_updated.R expeff glasso Blood >log/expeff_blood.log
Rscript infer_networks_updated.R expeff glasso Muscle >log/expeff_muscle.log

## gc_residuals
Rscript infer_networks_updated.R gc WGCNA >log/gc_wgcna.log
Rscript infer_networks_updated.R gc glasso Thyroid >log/gc_thyroid.log 
Rscript infer_networks_updated.R gc glasso Subcutaneous >log/gc_sub.log
Rscript infer_networks_updated.R gc glasso Lung >log/gc_lung.log
Rscript infer_networks_updated.R gc glasso Blood >log/gc_blood.log
Rscript infer_networks_updated.R gc glasso Muscle >log/gc_muscle.log

### pc
Rscript infer_networks_updated.R pc WGCNA >log/pc_wgcna.log
Rscript infer_networks_updated.R pc glasso Thyroid >log/pc_thyroid.log
Rscript infer_networks_updated.R pc glasso Subcutaneous >log/pc_sub.log
Rscript infer_networks_updated.R pc glasso Lung >log/pc_lung.log
Rscript infer_networks_updated.R pc glasso Blood >log/pc_blood.log
Rscript infer_networks_updated.R pc glasso Muscle >log/pc_muscle.log

## half-pc
Rscript infer_networks_updated.R halfpc WGCNA >log/halfpc_wgcna.log
Rscript infer_networks_updated.R halfpc glasso Thyroid >log/halfpc_thyroid.log
Rscript infer_networks_updated.R halfpc glasso Subcutaneous >log/halfpc_sub.log
Rscript infer_networks_updated.R halfpc glasso Lung >log/halfpc_lung.log
Rscript infer_networks_updated.R halfpc glasso Blood >log/halfpc_blood.log
Rscript infer_networks_updated.R halfpc glasso Muscle >log/halfpc_muscle.log

## quarter pc
Rscript infer_networks_updated.R quarter WGCNA >log/quarter_wgcna.log
Rscript infer_networks_updated.R quarter glasso Thyroid >log/quarter_thyroid.log
Rscript infer_networks_updated.R quarter glasso Subcutaneous >log/quarter_sub.log
Rscript infer_networks_updated.R quarter glasso Lung >log/quarter_lung.log
Rscript infer_networks_updated.R quarter glasso Blood >log/quarter_blood.log
Rscript infer_networks_updated.R quarter glasso Muscle >log/quarter_muscle.log


