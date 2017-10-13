#!/bin/sh
#SBATCH --time=3:0:0
#SBATCH --mem=40G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/src
Rscript wgcna_precision_recall.R Thyroid
Rscript wgcna_precision_recall.R Lung
Rscript wgcna_precision_recall.R Subcutaneous
Rscript wgcna_precision_recall.R Blood
Rscript wgcna_precision_recall.R Muscle
