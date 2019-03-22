#!/bin/bash

cd "$(dirname "$0")"

. ../env.sh

sed "s/BASE64ENCODED_CREDS/`cat key.json|base64 | tr -d '\n'`/g;s/PROJECT_ID/$PROJECT_ID/g" provider.yaml | kubectl create -f -

kubectl apply -f gke.yaml
kubectl apply -f cloudsql.yaml
kubectl apply -f workload.yaml