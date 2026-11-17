nextflow.enable.dsl=2

process DOCKER_TEST {

    label 'docker'

    output:
    path 'docker_test.txt'

    script:
    """
    echo "Nextflow + Docker integration successful." > docker_test.txt
    """
}

workflow {

    log.info "TNBC scRNA-seq ML GenAI pipeline initialized."

    DOCKER_TEST()
}
