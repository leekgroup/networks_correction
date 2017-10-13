#!/bin/sh
#SBATCH --time=00:40:0
#SBATCH --mem=30G

cd /home-3/pparsan1@jhu.edu/work2/princy/claire_network/Network-Inference/gtex_networks/publication_figures/fig4/

Rscript wgcna_edgecount.R 
#Rscript glasso_edgecount.R
