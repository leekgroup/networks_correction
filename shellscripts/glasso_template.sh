#!/bin/sh
#SBATCH --time=100:0:0
#SBATCH --mem=80G
#SBATCH --partition=unlimited

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

Rscript --no-save --no-restore --verbose infer_glasso.R $datDir/$1 $2 $networksDir/$3 >$logDir/$4
