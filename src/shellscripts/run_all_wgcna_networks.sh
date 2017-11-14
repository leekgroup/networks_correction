#!/bin/sh
#SBATCH --time=30:0:0
#SBATCH --mem=80G

cd /home-3/pparsan1@jhu.edu/work2/princy/networks_correction/src/
mkdir log


Rscript infer_networks_updated.R raw WGCNA >log/raw_wgcna.log 
Rscript infer_networks_updated.R rin WGCNA >log/rin_wgcna.log
Rscript infer_networks_updated.R exon WGCNA >log/exon_wgcna.log
Rscript infer_networks_updated.R expeff WGCNA >log/expeff_wgcna.log
Rscript infer_networks_updated.R pc WGCNA >log/pc_wgcna.log
Rscript infer_networks_updated.R halfpc WGCNA >log/halfpc_wgcna.log
Rscript infer_networks_updated.R quarter WGCNA >log/quarter_wgcna.log
Rscript infer_networks_updated.R gc WGCNA >log/gc_wgcna.log


## signed networks
Rscript infer_networks_updated.R raw WGCNA "" signed >log/raw_wgcna_signed.log
Rscript infer_networks_updated.R rin WGCNA "" signed >log/rin_wgcna_signed.log
Rscript infer_networks_updated.R exon WGCNA "" signed >log/exon_wgcna_signed.log
Rscript infer_networks_updated.R expeff WGCNA "" signed >log/expeff_wgcna_signed.log
Rscript infer_networks_updated.R pc WGCNA "" signed >log/pc_wgcna_signed.log
Rscript infer_networks_updated.R halfpc WGCNA "" signed >log/halfpc_wgcna_signed.log
Rscript infer_networks_updated.R quarter WGCNA "" signed >log/quarter_wgcna_signed.log
Rscript infer_networks_updated.R gc WGCNA "" signed >log/gc_wgcna_signed.log

