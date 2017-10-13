#!/bin/sh
#SBATCH --time=6:0:0
#SBATCH --mem=40G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/src
Rscript precision_recall.R Thyroid
Rscript precision_recall.R Lung
Rscript precision_recall.R Subcutaneous
Rscript precision_recall.R Blood
Rscript precision_recall.R Muscle
