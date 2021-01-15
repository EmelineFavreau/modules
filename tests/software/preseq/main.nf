#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PRESEQ_LCEXTRAP as PRESEQ_LCEXTRAP_SE } from '../../../software/preseq/lcextrap/main.nf' addParams( options: [ publish_dir:'test_preseq_single_end' ] )
include { PRESEQ_LCEXTRAP as PRESEQ_LCEXTRAP_PE } from '../../../software/preseq/lcextrap/main.nf' addParams( options: [ publish_dir:'test_preseq_paired_end' ] )

/*
 * Test with single-end data
 */

workflow test_preseq_single_end {

    def input = []
    input = [ [ id:'test', single_end:true ], // meta map
              [ file("${launchDir}/tests/data/bed/A.bed", checkIfExists: true) ]]
    PRESEQ_LCEXTRAP_SE ( input )
}

/*
 * Test with paired-end data
 */

workflow test_preseq_paired_end {

    def input = []
    input = [ [ id:'test', single_end:false ], // meta map
              [ file("${launchDir}/tests/data/bed/A.bed", checkIfExists: true) ]]

    PRESEQ_LCEXTRAP_PE ( input )
}

