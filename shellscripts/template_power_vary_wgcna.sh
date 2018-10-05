#!/bin/sh
#SBATCH --time=72:0:0
#SBATCH --mem=70G
#SBATCH --partition=parallel

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

test=$logDir/$4
echo $test
Rscript --no-save --no-restore --verbose infer_wgcna_vary_power.R $datDir/$1 $2 $networksDir/$3 >$logDir/$4 
