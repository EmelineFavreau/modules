// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

def options    = initOptions(params.options)

process BEDTOOLS_COMPLEMENT {
    tag "$meta.id"
    label 'process_medium'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:meta.id) }

    conda     (params.enable_conda ? "bioconda::bedtools =2.29.2" : null)
    container "quay.io/biocontainers/bedtools:2.29.2--hc088bd4_0"

    input:
        tuple val(meta), path(beds)
        path  sizes

    output:
        tuple val(meta), path("*.complement.bed"), emit: complement
        path  "*.version.txt", emit: version

    script:
        def software = getSoftwareName(task.process)
        def prefix   = options.suffix ? "${meta.id}${options.suffix}" : "${meta.id}"
        """
        bedtools complement -i $beds -g $sizes ${options.args} > ${prefix}.complement.bed
        bedtools --version | sed -e "s/Bedtools v//g" > ${software}.version.txt
        """
}
