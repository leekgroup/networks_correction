#!/bin/sh
#SBATCH --time=24:0:0
#SBATCH --mem=80G
#SBATCH --partition=lrgmem

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction_v/shellscripts/dirconfig

cd $scriptDir

Rscript infer_glasso.R $datDir/$1 $2 $networksDir/$3 >$logDir/$4
