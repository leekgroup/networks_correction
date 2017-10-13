#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --output=jupyter_%j.log
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=4gb
#SBATCH --time=02:00:00
#SBATCH --partition=debug
date;hostname;pwd
 
module load anaconda-python/2.7.12-1
port=$(shuf -i 20000-30000 -n 1)
 
echo -e "\nStarting Jupyter Notebook on port ${port} on the $(hostname) server."
echo -e "\nSSH tunnel command: ssh -NL 8080:$(hostname):${port} ${USER}@gateway2.marcc.jhu.edu"
echo -e "\nLocal URI: http://localhost:8080"
jupyter-notebook --no-browser --port=${port} --ip='*'
 
date
