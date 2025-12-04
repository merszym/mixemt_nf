process MASK_DEAMINATION{
    container (workflow.containerEngine ? "merszym/bam_deam:nextflow" : null)
    label 'local'

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("masked_${bam}"), path(bai), emit: bam

    script:
    def args = task.ext.args
    """
    mask_qual_scores.py ${bam} $args
    """
}