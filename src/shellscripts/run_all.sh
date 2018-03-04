#!/bin/sh
#SBATCH --time=96:0:0
#SBATCH --mem=70G

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrectsrc

mkdir log
mkdir /work-zfs/abattle4/parsana/networks_correction/plots/
#sh get_true_positive.sh >log/tp.log
Rscript dataDownload.R >log/download.log
Rscript process_gtex.R >log/process.log
Rscript attach_gc_recount.R >log/attach_gc_recount.log
Rscript covariate_correction.R >log/covariate_correction.log


cd $netcorrectsrc
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

### multiple 3 cov
Rscript infer_networks_updated.R multi3 WGCNA >log/multi3_wgcna.log
Rscript infer_networks_updated.R multi3 glasso Thyroid >log/multi3_thyroid.log
Rscript infer_networks_updated.R multi3 glasso Subcutaneous >log/multi3_sub.log
Rscript infer_networks_updated.R multi3 glasso Lung >log/multi3_lung.log
Rscript infer_networks_updated.R multi3 glasso Blood >log/multi3_blood.log
Rscript infer_networks_updated.R multi3 glasso Muscle >log/multi3_muscle.log

### multiple 7 cov
Rscript infer_networks_updated.R multi7 WGCNA >log/multi7_wgcna.log
Rscript infer_networks_updated.R multi7 glasso Thyroid >log/multi7_thyroid.log
Rscript infer_networks_updated.R multi7 glasso Subcutaneous >log/multi7_sub.log
Rscript infer_networks_updated.R multi7 glasso Lung >log/multi7_lung.log
Rscript infer_networks_updated.R multi7 glasso Blood >log/multi7_blood.log
Rscript infer_networks_updated.R multi7 glasso Muscle >log/multi7_muscle.log


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


