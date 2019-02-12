#!/bin/bash -l
#SBATCH
#SBATCH --mail-type=END
#SBATCH --mail-user=pparsan1@jhu.edu
#SBATCH --time=1:0:0
#SBATCH --partition=lrgmem
#SBATCH --mem=10G


module load gcc/5.5.0
module load R/3.4.0

cd /work-zfs/abattle4/parsana/networks_correction/publication_rmd/simulation_scale-free_matched_gtex/weighted_confound/
Rscript generate_sim_data.R >log/generate_sim_data.log


