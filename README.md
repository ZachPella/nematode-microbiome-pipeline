# Nematode Microbiome Pipeline

A comprehensive bioinformatics pipeline for taxonomic classification and community analysis of nematode-associated microbiomes using unmapped sequencing reads.

## Overview

This pipeline extracts unmapped reads from aligned genomic data and performs taxonomic classification to characterize microbial communities associated with nematodes. The workflow includes quality control, taxonomic classification using Kraken2/Bracken, and statistical community analysis.

## Pipeline Steps

### 1. Extract Unmapped Reads (`1_get_unmapped.sh`)
- Extracts paired-end reads where both mates are unmapped from BAM files
- Converts to FASTQ format for downstream analysis
- **Input**: `*.sorted.refrename.bam`
- **Output**: `fastq_for_assembly/*.unmapped.R{1,2}.fastq`

### 2. Quality Control (`2x_run_fastqc.sh`)
- Runs FastQC on all unmapped FASTQ files
- Generates MultiQC summary report
- **Output**: `fastqc_results/`

### 3. Read Trimming (`3x_run_trimming.sh`)
- Quality trimming using Trimmomatic
- Removes low-quality bases and short reads
- **Output**: `trimmed_fastq/*.trimmed.R{1,2}.fastq`

### 4. Taxonomic Classification (`4x_run_kraken2.sh`)
- Kraken2 taxonomic classification against standard database
- Bracken abundance estimation at multiple taxonomic levels (Species, Genus, Family, Order, Class, Phylum)
- **Output**: `kraken2_output/`, `bracken_output/`

### 5. Combine Results (`5x_combine_results.sh`)
- Combines Bracken outputs across all samples
- Generates read count summary
- **Output**: `combined_bracken_species.txt`

### 6. Statistical Analysis (`6x_run_r_analysis.sh`)
- NMDS ordination using Bray-Curtis dissimilarities
- Diversity indices (Shannon, Simpson, richness, evenness)
- Community analysis using vegan package in R
- **Output**: NMDS plots, diversity metrics, community matrices

## Requirements

### Software Dependencies
- **SLURM** (job scheduler)
- **samtools** (≥1.9)
- **FastQC** and **MultiQC**
- **Trimmomatic**
- **Kraken2** (v2.0.8-beta) with standard database
- **Bracken**
- **R** (≥4.0) with packages: `vegan`, `ecodist`

### System Requirements
- HPC cluster with SLURM
- Memory: 8-50GB depending on step
- CPUs: 1-8 cores per job
- Storage: ~50GB per sample for intermediate files

## Usage

### Quick Start
```bash
# 1. Extract unmapped reads (array job for multiple samples)
sbatch 1_get_unmapped.sh

# 2. Quality control
sbatch 2x_run_fastqc.sh

# 3. Trim reads (optional but recommended)
sbatch 3x_run_trimming.sh

# 4. Taxonomic classification
sbatch 4x_run_kraken2.sh

# 5. Combine results
sbatch 5x_combine_results.sh

# 6. Statistical analysis
sbatch 6x_run_r_analysis.sh
```

### Input Data Structure
```
project_directory/
├── *.sorted.refrename.bam    # Input BAM files
├── 1_get_unmapped.sh         # Pipeline scripts
├── 2x_run_fastqc.sh
├── ...
└── microbiome_analysis.R     # R analysis script
```

### Output Structure
```
project_directory/
├── fastq_for_assembly/       # Unmapped FASTQ files
├── fastqc_results/          # Quality control reports
├── trimmed_fastq/           # Trimmed reads
├── kraken2_output/          # Taxonomic classifications
├── bracken_output/          # Abundance estimates
├── combined_bracken_species.txt  # Combined results
├── NMDS_plot.pdf            # Ordination plot
├── diversity_indices.csv    # Diversity metrics
└── community_matrix.csv     # Species abundance matrix
```

## Key Features

- **Scalable**: Uses SLURM array jobs for parallel processing
- **Robust**: Includes quality control and read trimming steps
- **Comprehensive**: Multi-level taxonomic classification (Species through Phylum)
- **Publication-ready**: Statistical analysis following established methods
- **Well-documented**: Clear output files and logging

## Expected Results

- **NMDS ordination** with stress values <0.2 (excellent fit <0.1)
- **Diversity metrics** for each sample
- **Community composition** at species level
- **Taxonomic profiles** at multiple hierarchical levels

## Customization

### Modifying Parameters
- **Trimmomatic settings**: Edit quality thresholds in `3x_run_trimming.sh`
- **Kraken2 database**: Change `$KRAKEN2_DB` path in `4x_run_kraken2.sh`
- **Bracken levels**: Modify taxonomic levels in the for loop
- **R analysis**: Add experimental metadata for group comparisons

### Sample Size
- Array job indices in scripts assume 9 samples
- Modify `--array=1-N` to match your sample count
- Update FastQC array size (2× number of samples for R1/R2)

## Citation

If you use this pipeline, please cite the relevant tools:
- **Kraken2**: Wood et al. (2019) Genome Biology
- **Bracken**: Lu et al. (2017) PeerJ Computer Science
- **vegan R package**: Oksanen et al. (2022)

## Troubleshooting

### Common Issues
1. **Module loading**: Adjust module names for your HPC system
2. **Memory limits**: Increase `--mem` if jobs fail with OOM errors
3. **Database access**: Ensure `$KRAKEN2_DB` environment variable is set
4. **R packages**: Install to user library if system-wide installation fails

### Support
For questions or issues, please open a GitHub issue with:
- Error messages
- System information
- Input data characteristics

## License

MIT License - feel free to use and modify for your research.

---

**Pipeline developed for nematode microbiome analysis**  
*Taxonomic classification of unmapped reads → Community analysis*
