#!/bin/bash
#SBATCH --job-name=combine_results
#SBATCH --output=combine_%j.out
#SBATCH --error=combine_%j.err
#SBATCH --mem=8G
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1

cd /work/fauverlab/zachpella/braker_run/unmapped_reads/bams_surface_sterlizied_namericanus_l3s_for_ZP/fastq_og

# Load modules
module load kraken2/2.0.8-beta
module load bracken

# Combine Bracken results
if [ -d "bracken_output" ]; then
    echo "Combining Bracken results..."
    combine_bracken_outputs.py \
        --files bracken_output/*.bracken.S.output \
        -o combined_bracken_species.txt
fi

# Create summary report with bash instead of Python
echo "Creating summary report..."
echo "Sample Read Counts:"
echo "=================================================="
for r1_file in fastq_for_assembly/*.unmapped.R1.fastq; do
    if [ -f "$r1_file" ]; then
        sample=$(basename "$r1_file" .unmapped.R1.fastq)
        num_lines=$(wc -l < "$r1_file")
        num_reads=$((num_lines / 4))
        # Format with commas (if supported by your system)
        printf "%s: %'d unmapped read pairs\n" "$sample" "$num_reads" 2>/dev/null || \
        printf "%s: %d unmapped read pairs\n" "$sample" "$num_reads"
    fi
done
echo "=================================================="
