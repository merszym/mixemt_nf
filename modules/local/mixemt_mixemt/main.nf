process MIXEMT {
    container (workflow.containerEngine ? "merszym/mixemt:nextflow" : null)
    tag "${meta.id}"
    label "process_low"
    label 'local'

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("*.npy"), path('*.reads'), path("*.haps"),path("*.txt"), emit: mixemt
    path "versions.yml"                                                          , emit: versions

    script:
    def args = task.ext.args ?: ''
    """    
    mixemt $args -s ${meta.id} ${bam} > ${meta.id}_mixemt.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mixemt: not version tracked
    END_VERSIONS
    """
}