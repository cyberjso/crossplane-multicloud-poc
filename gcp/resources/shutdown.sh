#!/bin/bash

cd "$(dirname "$0")"

kubectl delete -f workload.yaml
kubectl delete -f cloudsql.yaml
kubectl delete -f gke.yaml