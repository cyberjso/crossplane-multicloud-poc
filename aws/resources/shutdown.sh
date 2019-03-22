#!/bin/bash

cd "$(dirname "$0")"

kubectl delete -f workload.yaml
kubectl delete -f rds.yaml
kubectl delete -f eks.yaml
kubectl delete -f provider.yaml