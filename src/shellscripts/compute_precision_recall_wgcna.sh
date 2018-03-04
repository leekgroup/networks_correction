#!/bin/sh
#SBATCH --time=3:0:0
#SBATCH --mem=40G

cd /work-zfs/abattle4/parsana/networks_correction/src
Rscript wgcna_precision_recall.R Thyroid
Rscript wgcna_precision_recall.R Lung
Rscript wgcna_precision_recall.R Subcutaneous
Rscript wgcna_precision_recall.R Blood
Rscript wgcna_precision_recall.R Muscle
