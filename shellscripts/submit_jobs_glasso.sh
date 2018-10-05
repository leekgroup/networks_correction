## submit jobs for raw

sbatch --job-name=raw_sub glasso_template.sh raw_subset.Rdata Subcutaneous raw/Subcutaneous_glasso_networks.Rdata subcutaneous_raw_glasso.log

sbatch --job-name=raw_lung glasso_template.sh raw_subset.Rdata Lung raw/Lung_glasso_networks.Rdata lung_raw_glasso.log

sbatch --job-name=raw_thyroid glasso_template.sh raw_subset.Rdata Thyroid raw/Thyroid_glasso_networks.Rdata thyroid_raw_glasso.log

sbatch --job-name=raw_muscle glasso_template.sh raw_subset.Rdata Muscle raw/Muscle_glasso_networks.Rdata muscle_raw_glasso.log

sbatch --job-name=raw_blood glasso_template.sh raw_subset.Rdata Blood raw/Blood_glasso_networks.Rdata blood_raw_glasso.log

sbatch --job-name=raw_artery glasso_template.sh raw_subset.Rdata Artery_tibial raw/Artery_tibial_glasso_networks.Rdata artery_tibial_raw_glasso.log

sbatch --job-name=raw_nerve glasso_template.sh raw_subset.Rdata Nerve_tibial raw/Nerve_tibial_glasso_networks.Rdata nerve_tibial_raw_glasso.log

sbatch --job-name=raw_skin glasso_template.sh raw_subset.Rdata Skin raw/Skin_glasso_networks.Rdata skin_raw_glasso.log

# submit jobs for rin
sbatch --job-name=rin_sub glasso_template.sh rin_corrected.Rdata Subcutaneous rin/Subcutaneous_glasso_networks.Rdata subcutaneous_rin_glasso.log

sbatch --job-name=rin_lung glasso_template.sh rin_corrected.Rdata Lung rin/Lung_glasso_networks.Rdata lung_rin_glasso.log

sbatch --job-name=rin_thyroid glasso_template.sh rin_corrected.Rdata Thyroid rin/Thyroid_glasso_networks.Rdata thyroid_rin_glasso.log

sbatch --job-name=rin_muscle glasso_template.sh rin_corrected.Rdata Muscle rin/Muscle_glasso_networks.Rdata muscle_rin_glasso.log

sbatch --job-name=rin_blood glasso_template.sh rin_corrected.Rdata Blood rin/Blood_glasso_networks.Rdata blood_rin_glasso.log

sbatch --job-name=rin_artery glasso_template.sh rin_corrected.Rdata Artery_tibial rin/Artery_tibial_glasso_networks.Rdata artery_tibial_rin_glasso.log

sbatch --job-name=rin_nerve glasso_template.sh rin_corrected.Rdata Nerve_tibial rin/Nerve_tibial_glasso_networks.Rdata nerve_tibial_rin_glasso.log

sbatch --job-name=rin_skin glasso_template.sh rin_corrected.Rdata Skin rin/Skin_glasso_networks.Rdata skin_rin_glasso.log

# submit jobs for gc
sbatch --job-name=gc_sub glasso_template.sh gc_corrected.Rdata Subcutaneous gc/Subcutaneous_glasso_networks.Rdata subcutaneous_gc_glasso.log

sbatch --job-name=gc_lung glasso_template.sh gc_corrected.Rdata Lung gc/Lung_glasso_networks.Rdata lung_gc_glasso.log

sbatch --job-name=gc__thyroid glasso_template.sh gc_corrected.Rdata Thyroid gc/Thyroid_glasso_networks.Rdata thyroid_gc_glasso.log

sbatch --job-name=gc_muscle glasso_template.sh gc_corrected.Rdata Muscle gc/Muscle_glasso_networks.Rdata muscle_gc_glasso.log

sbatch --job-name=gc_blood glasso_template.sh gc_corrected.Rdata Blood gc/Blood_glasso_networks.Rdata blood_gc_glasso.log

sbatch --job-name=gc_artery glasso_template.sh gc_corrected.Rdata Artery_tibial gc/Artery_tibial_glasso_networks.Rdata artery_tibial_gc_glasso.log

sbatch --job-name=gc_nerve glasso_template.sh gc_corrected.Rdata Nerve_tibial gc/Nerve_tibial_glasso_networks.Rdata nerve_tibial_gc_glasso.log

sbatch --job-name=gc_skin glasso_template.sh gc_corrected.Rdata Skin gc/Skin_glasso_networks.Rdata skin_gc_glasso.log

# sumit jobs for exonicRate
sbatch --job-name=exonicRate_sub glasso_template.sh exonicRate_corrected.Rdata Subcutaneous exonicRate/Subcutaneous_glasso_networks.Rdata subcutaneous_exonicRate_glasso.log

sbatch --job-name=exonicRate_lung glasso_template.sh exonicRate_corrected.Rdata Lung exonicRate/Lung_glasso_networks.Rdata lung_exonicRate_glasso.log

sbatch --job-name=exonicRate_thyroid glasso_template.sh exonicRate_corrected.Rdata Thyroid exonicRate/Thyroid_glasso_networks.Rdata thyroid_exonicRate_glasso.log

sbatch --job-name=exonicRate_muscle glasso_template.sh exonicRate_corrected.Rdata Muscle exonicRate/Muscle_glasso_networks.Rdata muscle_exonicRate_glasso.log

sbatch --job-name=exonicRate_artery glasso_template.sh exonicRate_corrected.Rdata Artery_tibial exonicRate/Artery_tibial_glasso_networks.Rdata artery_tibial_exonicRate_glasso.log

sbatch --job-name=exonicRate_nerve glasso_template.sh exonicRate_corrected.Rdata Nerve_tibial exonicRate/Nerve_tibial_glasso_networks.Rdata nerve_tibial_exonicRate_glasso.log

sbatch --job-name=exonicRate_skin glasso_template.sh exonicRate_corrected.Rdata Skin exonicRate/Skin_glasso_networks.Rdata skin_exonicRate_glasso.log

sbatch --job-name=exonicRate_blood glasso_template.sh exonicRate_corrected.Rdata Blood exonicRate/Blood_glasso_networks.Rdata blood_exonicRate_glasso.log

# submit jobs for mc
sbatch --job-name=mc_sub glasso_template.sh mc_corrected.Rdata Subcutaneous mc/Subcutaneous_glasso_networks.Rdata subcutaneous_mc_glasso.log

sbatch --job-name=mc_lung glasso_template.sh mc_corrected.Rdata Lung mc/Lung_glasso_networks.Rdata lung_mc_glasso.log

sbatch --job-name=mc_thyroid glasso_template.sh mc_corrected.Rdata Thyroid mc/Thyroid_glasso_networks.Rdata thyroid_mc_glasso.log

sbatch --job-name=mc_muscle glasso_template.sh mc_corrected.Rdata Muscle mc/Muscle_glasso_networks.Rdata muscle_mc_glasso.log

sbatch --job-name=mc_blood glasso_template.sh mc_corrected.Rdata Blood mc/Blood_glasso_networks.Rdata blood_mc_glasso.log

sbatch --job-name=mc_artery glasso_template.sh mc_corrected.Rdata Artery_tibial mc/Artery_tibial_glasso_networks.Rdata artery_tibial_mc_glasso.log

sbatch --job-name=mc_nerve glasso_template.sh mc_corrected.Rdata Nerve_tibial mc/Nerve_tibial_glasso_networks.Rdata nerve_tibial_mc_glasso.log

sbatch --job-name=mc_skin glasso_template.sh mc_corrected.Rdata Skin mc/Skin_glasso_networks.Rdata skin_mc_glasso.log

# submit jobs for quarter pc
sbatch --job-name=qpc_sub glasso_template.sh quarterpc_corrected.Rdata Subcutaneous quarterpc/Subcutaneous_glasso_networks.Rdata subcutaneous_quarterpc_glasso.log

sbatch --job-name=qpc_lung glasso_template.sh quarterpc_corrected.Rdata Lung quarterpc/Lung_glasso_networks.Rdata lung_quarterpc_glasso.log

sbatch --job-name=qpc_thyroid glasso_template.sh quarterpc_corrected.Rdata Thyroid quarterpc/Thyroid_glasso_networks.Rdata thyroid_quarterpc_glasso.log

sbatch --job-name=qpc_muscle glasso_template.sh quarterpc_corrected.Rdata Muscle quarterpc/Muscle_glasso_networks.Rdata muscle_quarterpc_glasso.log

sbatch --job-name=qpc_blood glasso_template.sh quarterpc_corrected.Rdata Blood quarterpc/Blood_glasso_networks.Rdata blood_quarterpc_glasso.log

sbatch --job-name=quarterpc_artery glasso_template.sh quarterpc_corrected.Rdata Artery_tibial quarterpc/Artery_tibial_glasso_networks.Rdata artery_tibial_quarterpc_glasso.log

sbatch --job-name=quarterpc_nerve glasso_template.sh quarterpc_corrected.Rdata Nerve_tibial quarterpc/Nerve_tibial_glasso_networks.Rdata nerve_tibial_quarterpc_glasso.log

sbatch --job-name=quarterpc_skin glasso_template.sh quarterpc_corrected.Rdata Skin quarterpc/Skin_glasso_networks.Rdata skin_quarterpc_glasso.log

# submit jobs for halfpc
sbatch --job-name=hpc_sub glasso_template.sh halfpc_corrected.Rdata Subcutaneous halfpc/Subcutaneous_glasso_networks.Rdata subcutaneous_halfpc_glasso.log

sbatch --job-name=hpc_lung glasso_template.sh halfpc_corrected.Rdata Lung halfpc/Lung_glasso_networks.Rdata lung_halfpc_glasso.log

sbatch --job-name=hpc_thyroid glasso_template.sh halfpc_corrected.Rdata Thyroid halfpc/Thyroid_glasso_networks.Rdata thyroid_halfpc_glasso.log

sbatch --job-name=hpc_muscle glasso_template.sh halfpc_corrected.Rdata Muscle halfpc/Muscle_glasso_networks.Rdata muscle_halfpc_glasso.log

sbatch --job-name=hpc_blood glasso_template.sh halfpc_corrected.Rdata Blood halfpc/Blood_glasso_networks.Rdata blood_halfpc_glasso.log

sbatch --job-name=halfpc_artery glasso_template.sh halfpc_corrected.Rdata Artery_tibial halfpc/Artery_tibial_glasso_networks.Rdata artery_tibial_halfpc_glasso.log

sbatch --job-name=halfpc_nerve glasso_template.sh halfpc_corrected.Rdata Nerve_tibial halfpc/Nerve_tibial_glasso_networks.Rdata nerve_tibial_halfpc_glasso.log

sbatch --job-name=halfpc_skin glasso_template.sh halfpc_corrected.Rdata Skin halfpc/Skin_glasso_networks.Rdata skin_halfpc_glasso.log

# submit jobs for pc
sbatch --job-name=pc_sub glasso_template.sh pc_corrected.Rdata Subcutaneous pc/Subcutaneous_glasso_networks.Rdata subcutaneous_pc_glasso.log

sbatch --job-name=pc_lung glasso_template.sh pc_corrected.Rdata Lung pc/Lung_glasso_networks.Rdata lung_pc_glasso.log

sbatch --job-name=pc_thyroid glasso_template.sh pc_corrected.Rdata Thyroid pc/Thyroid_glasso_networks.Rdata thyroid_pc_glasso.log

sbatch --job-name=pc_muscle glasso_template.sh pc_corrected.Rdata Muscle pc/Muscle_glasso_networks.Rdata muscle_pc_glasso.log

sbatch --job-name=pc_blood glasso_template.sh pc_corrected.Rdata Blood pc/Blood_glasso_networks.Rdata blood_pc_glasso.log

sbatch --job-name=pc_artery glasso_template.sh pc_corrected.Rdata Artery_tibial pc/Artery_tibial_glasso_networks.Rdata artery_tibial_pc_glasso.log

sbatch --job-name=pc_nerve glasso_template.sh pc_corrected.Rdata Nerve_tibial pc/Nerve_tibial_glasso_networks.Rdata nerve_tibial_pc_glasso.log

sbatch --job-name=pc_skin glasso_template.sh pc_corrected.Rdata Skin pc/Skin_glasso_networks.Rdata skin_pc_glasso.log
