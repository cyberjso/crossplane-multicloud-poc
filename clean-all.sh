#!/bin/bash
cd "$(dirname "$0")"

./aws/resources/shutdown.sh
aws cloudformation delete-stack --stack-name crossplane-stack
./gcp/resources/shutdown.sh
gcloud container clusters delete multi-cloud-poc
