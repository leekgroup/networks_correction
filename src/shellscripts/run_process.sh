#!/bin/sh
#SBATCH --time=12:0:0
#SBATCH --mem=70G

source /work-zfs/abattle4/parsana/networks_correction/src/shellscripts/dirconfig
cd $netcorrectsrc

Rscript process_gtex.R >log/process.log
