#!/bin/sh
#SBATCH --time=6:0:0
#SBATCH --mem=40G

cd /work-zfs/abattle4/parsana/networks_correction/networks_correction/src
Rscript precision_recall.R Thyroid
Rscript precision_recall.R Lung
Rscript precision_recall.R Subcutaneous
Rscript precision_recall.R Blood
Rscript precision_recall.R Muscle
