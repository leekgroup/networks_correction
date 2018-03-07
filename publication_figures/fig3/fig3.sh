#!/bin/sh
#SBATCH --time=10:40:0
#SBATCH --mem=50G

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrecthome/publication_figures/fig3/
Rscript process_fig3.R
