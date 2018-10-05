#!/bin/sh
#SBATCH --time=72:0:0
#SBATCH --mem=70G
#SBATCH --partition=shared

source ~/.bash_profile
source /work-zfs/abattle4/parsana/networks_correction/shellscripts/dirconfig

cd $scriptDir

## WGCNA networks
mkdir $networksDir/raw/
mkdir $networksDir/rin/
mkdir $networksDir/gc/
mkdir $networksDir/pc/
mkdir $networksDir/halfpc/
mkdir $networksDir/quarterpc/
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/raw_subset.Rdata signed $networksDir/raw/signed_wgcna_networks.Rdata >$logDir/raw_signed_wgcna.log 2>&1
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/rin_corrected.Rdata signed $networksDir/rin/signed_wgcna_networks.Rdata >$logDir/rin_signed_wgcna.log 2>&1
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/gc_corrected.Rdata signed $networksDir/gc/signed_wgcna_networks.Rdata >$logDir/gc_signed_wgcna.log 2>&1
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/exonicRate_corrected.Rdata signed $networksDir/exonicRate/signed_wgcna_networks.Rdata >$logDir/exonicRate_signed_wgcna.log 2>&1
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/mc_corrected.Rdata signed $networksDir/mc/signed_wgcna_networks.Rdata >$logDir/mc_signed_wgcna.log 2>&1
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/pc_corrected.Rdata signed $networksDir/pc/signed_wgcna_networks.Rdata >$logDir/pc_signed_wgcna.log 2>&1
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/halfpc_corrected.Rdata signed $networksDir/halfpc/signed_wgcna_networks.Rdata >$logDir/halfpc_signed_wgcna.log 2>&1
Rscript --no-save --no-restore --verbose infer_wgcna.R $datDir/quarterpc_corrected.Rdata signed $networksDir/quarterpc/signed_wgcna_networks.Rdata >$logDir/quarterpc_signed_wgcna.log 2>&1

