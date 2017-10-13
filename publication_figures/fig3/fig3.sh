#!/bin/sh
#SBATCH --time=3:40:0
#SBATCH --mem=50G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig3/
Rscript process_fig3.R
