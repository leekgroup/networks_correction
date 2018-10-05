sbatch --job-name=raw_wgcna_varypower template_power_vary_wgcna.sh raw_subset.Rdata signed raw/power_wgcna_networks.Rdata r2_varypowerraw_wgcna.log

sbatch --job-name=rin_wgcna_varypower template_power_vary_wgcna.sh rin_corrected.Rdata signed rin/power_wgcna_networks.Rdata r2_varypowerrin_wgcna.log

sbatch --job-name=gc_wgcna_varypower template_power_vary_wgcna.sh gc_corrected.Rdata signed gc/power_wgcna_networks.Rdata r2_varypowergc_wgcna.log

sbatch --job-name=mc_wgcna_varypower template_power_vary_wgcna.sh mc_corrected.Rdata signed mc/power_wgcna_networks.Rdata r2_varypowermc_wgcna.log

sbatch --job-name=exonicRate_wgcna_varypower template_power_vary_wgcna.sh exonicRate_corrected.Rdata signed exonicRate/power_wgcna_networks.Rdata r2_varypowerexonicRate_wgcna.log

sbatch --job-name=pc_wgcna_varypower template_power_vary_wgcna.sh pc_corrected.Rdata signed pc/power_wgcna_networks.Rdata r2_varypowerpc_wgcna.log

sbatch --job-name=halfpc_wgcna_varypower template_power_vary_wgcna.sh halfpc_corrected.Rdata signed halfpc/power_wgcna_networks.Rdata r2_varypowerhalfpc_wgcna.log

sbatch --job-name=quarterpc_wgcna_varypower template_power_vary_wgcna.sh quarterpc_corrected.Rdata signed quarterpc/power_wgcna_networks.Rdata r2_varypowerquarterpc_wgcna.log


