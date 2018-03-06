#!/bin/sh
#SBATCH --time=01:00:0
#SBATCH --mem=30G

cd $parsana/networks_correction/publication_figures/fig2/
Rscript process_fig2.R
