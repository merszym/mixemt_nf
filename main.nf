#!/usr/bin/env nextflow

// include workflows for different executions of the pipeline
include { splitdir }         from './workflows/01_splitdir'
include { MASK_DEAMINATION } from './modules/local/mask_deamination'
include { SAMTOOLS_INDEX }   from './modules/local/samtools_index'
include { MIXEMT   }         from './modules/local/mixemt_mixemt'


//
//
// Help
//
//

if (params.help){
    print file("$baseDir/assets/pipeline/help.txt").text
    exit 0
}


//
//
// input Channels
//
//

ch_split = params.split ? Channel.fromPath("${params.split}/*", checkIfExists:true) : ""

ch_versions = Channel.empty()

//
//
// The main workflow
//
//

workflow {

    //
    // 1. Input Processing ~ Input Parameters
    //

    splitdir( ch_split )

    ch_bam = splitdir.out.bams
    ch_versions = ch_versions.mix( splitdir.out.versions )

    //
    // 2. Mask first and last N basepairs to have quality 0 
    //

    MASK_DEAMINATION(ch_bam)

    ch_masked_bam = MASK_DEAMINATION.out.bam

    //
    // 3. Run MixEMT
    //

    SAMTOOLS_INDEX(ch_masked_bam)
    ch_indexed_bam = SAMTOOLS_INDEX.out.bam
    
    MIXEMT(ch_indexed_bam)
}
