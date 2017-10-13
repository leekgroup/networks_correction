#!/bin/sh
#SBATCH --time=01:00:0
#SBATCH --mem=30G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig2/
Rscript process_fig2.R
