#!/bin/sh
#SBATCH --time=00:40:0
#SBATCH --mem=30G

source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrecthome/publication_figures/fig4/

Rscript wgcna_edgecount.R 
Rscript glasso_edgecount.R
