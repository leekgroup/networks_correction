#!/bin/sh
#SBATCH --time=12:0:0
#SBATCH --mem=70G

cd /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/src/

Rscript process_gtex.R >log/process.log
