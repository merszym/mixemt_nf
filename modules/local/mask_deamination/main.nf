process MASK_DEAMINATION{
    container (workflow.containerEngine ? "merszym/bam_deam:nextflow" : null)
    label 'local'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("masked_${bam}"), emit: bam

    script:
    def args = task.ext.args
    """
    mask_qual_scores.py ${bam} $args
    """
}