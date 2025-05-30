#!/usr/bin/env nextflow

// include workflows for different executions of the pipeline
include { splitdir } from './workflows/01_splitdir'
include { MIXEMT   } from './modules/local/mixemt_mixemt'


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

    MIXEMT(ch_bam)
    MIXEMT.out.mixemt.view()
}
