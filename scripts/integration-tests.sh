#!/bin/bash

source /scripts/common.sh
source /scripts/bootstrap-helm.sh


run_tests() {
    echo Running tests...

    wait_pod_ready givethbot
}

teardown() {
    helm delete givethbot
}

main(){
    if [ -z "$KEEP_W3F_GIVETHBOT" ]; then
        trap teardown EXIT
    fi

    /scripts/build-helm.sh \
        --set environment=ci \
        --set image.tag="${CIRCLE_SHA1}" \
        givethbot \
        ./charts/givethbot

    run_tests
}

main
