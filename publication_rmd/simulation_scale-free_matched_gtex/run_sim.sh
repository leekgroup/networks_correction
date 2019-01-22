#!/bin/bash -l
#SBATCH
#SBATCH --mail-type=END
#SBATCH --mail-user=pparsan1@jhu.edu
#SBATCH --time=72:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks-per-node=25
#SBATCH --mem=70G


module load gcc/5.5.0
module load R/3.4.0

cd /work-zfs/abattle4/parsana/temp/scale-free_matched_sim/
Rscript sim.R >sim_log
