#!/bin/bash -l
#SBATCH
#SBATCH --mail-type=END
#SBATCH --mail-user=pparsan1@jhu.edu
#SBATCH --time=72:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks-per-node=10
#SBATCH --mem=55G

module load gcc/5.5.0
module load R/3.4.0

cd /work-zfs/abattle4/parsana/networks_correction/publication_rmd/simulation_scale-free_matched_gtex/overlap_confound
Rscript infer_nets.R $1 >log/$1.log
