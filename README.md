# mixEMT pipeline

This is a _really_ simple pipeline that calls mtDNA haplogroup-mixes with mixEMT.

Given a folder with pre-filtered BAM or FASTQ files (unique Hominin mtDNA sequences), this pipeline runs mixEMT with very sensitive settings (r=5, f=0.3, and R=2) on each of the files individually and saves the output to a text-file.

The quality-score of each sequences end bases is set to 0 before haplogroup assignment (--trim flag) to mitigate ancient DNA damage effects and the mapping-quality filter threshold for mixemt is therefore set to 0 (so filter for MQ yourself beforehand).

## Requirements

- singularity 
- nextflow v22.10 (or larger)

## Run the pipeline

Run the pipeline with
```
export NXF_SINGULARITY_CACHEDIR="PATH" // place of stored singularity containers
nextflow run merszym/mixemt_nf --split PATH <flags>
```

**Flags**
```
--split     PATH   A folder containing bam-files to analyze!
--trim      N      Trim N bases on each end of DNA reads before running kallisto (default: 3)
--mixemt_f  N      Fraction of unique defining variants that must be observed (default: 0.3)
--mixemt_r  N      The number of reads a haplogroup must have to be considered a contributor (default: 5)
--mixemt_R  N      The minimum number of reads that need to carry a variant to be considered (default: 2)
```

