include { SAMTOOLS_SORT }   from '../modules/local/samtools_sort'
include { SAMTOOLS_INDEX }  from '../modules/local/samtools_index'
include { SAMTOOLS_FQ2BAM } from '../modules/local/samtools_fq2bam'

// some required functions
def has_ending(file, extension){
    return extension.any{ file.toString().toLowerCase().endsWith(it) }
}

workflow splitdir {
    take:
        ch_split
    main:
        ch_versions = Channel.empty()

        ch_split
            .map{ [['id':it.baseName], it] }
                .branch {
                    bam: it[1].getExtension() == 'bam'
                    fastq: has_ending( it[1], ["fastq","fastq.gz","fq","fq.gz"])
                    stats:  it[1].name =~ /split.*stats/
                    fail: true
                }
                .set{ ch_split }


        // convert fastq to bam
        SAMTOOLS_FQ2BAM( ch_split.fastq )
        
        ch_bams = ch_split.bam.mix( SAMTOOLS_FQ2BAM.out.bam )
        ch_versions = ch_versions.mix(SAMTOOLS_FQ2BAM.out.versions.first())

        SAMTOOLS_SORT(ch_bams)
        ch_versions = ch_versions.mix(SAMTOOLS_SORT.out.versions.first())


    emit:
        bams = SAMTOOLS_SORT.out.bam
        versions = ch_versions
}