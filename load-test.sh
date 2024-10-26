#!/bin/bash

NAMESPACE="mamikos-devops"
LOAD_GENERATOR_PREFIX="load-generator"
YAML_PATH="./kubernetes/load-generator-pod.yaml"

function start_load_generators() {
    echo "Starting load generator pods..."
    for i in {1..5}; do
        POD_NAME="${LOAD_GENERATOR_PREFIX}-${i}"
        sed "s/{{ID}}/${i}/g" "${YAML_PATH}" | kubectl apply -f -
    done
    echo "Load generator pods started."
}

function stop_load_generators() {
    echo "Stopping load generator pods..."
    for i in {1..5}; do
        kubectl delete pod "${LOAD_GENERATOR_PREFIX}-${i}" -n "${NAMESPACE}" --ignore-not-found
    done
    echo "Load generator pods stopped."
}

if [[ "$1" == "start" ]]; then
    start_load_generators
elif [[ "$1" == "stop" ]]; then
    stop_load_generators
else
    echo "Usage: $0 {start|stop}"
    exit 1
fi


##SCRPT ini digunakan untuk melakuakn testing load-testing, dengan trigger threshold CPU yakni 25%. Untuk melihat apakah konfigurasi HPA dapat melakukan scaling sesuai dengan kondisi yang ditentukan

