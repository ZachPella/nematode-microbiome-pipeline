#!/bin/bash
#SBATCH --job-name=microbiome_analysis
#SBATCH --output=r_analysis_%j.out
#SBATCH --error=r_analysis_%j.err
#SBATCH --mem=16G
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=1

cd /work/fauverlab/zachpella/braker_run/unmapped_reads/bams_surface_sterlizied_namericanus_l3s_for_ZP/fastq_og

# Load R module
module load R  # adjust version as needed

# Run the microbiome analysis
echo "Running microbiome analysis..."
Rscript microbiome_analysis.R

echo "Analysis complete!"
