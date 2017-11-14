#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=80G

cd /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/src/
mkdir log

## signed networks
Rscript infer_networks_updated.R raw WGCNA "" signed >log/raw_wgcna_signed.log
Rscript infer_networks_updated.R rin WGCNA "" signed >log/rin_wgcna_signed.log
Rscript infer_networks_updated.R exon WGCNA "" signed >log/exon_wgcna_signed.log
Rscript infer_networks_updated.R expeff WGCNA "" signed >log/expeff_wgcna_signed.log
Rscript infer_networks_updated.R pc WGCNA "" signed >log/pc_wgcna_signed.log
Rscript infer_networks_updated.R halfpc WGCNA "" signed >log/halfpc_wgcna_signed.log
Rscript infer_networks_updated.R quarter WGCNA "" signed >log/quarter_wgcna_signed.log
Rscript infer_networks_updated.R gc WGCNA "" signed >log/gc_wgcna_signed.log
