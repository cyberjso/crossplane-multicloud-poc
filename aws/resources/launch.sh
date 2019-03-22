#!/bin/bash

cd "$(dirname "$0")"

. env.sh

sed "s/EKS_VPC/$EKS_VPC/g;s/EKS_SUBNETS/$EKS_SUBNETS/g;s/EKS_SECURITY_GROUP/$EKS_SECURITY_GROUP/g;s/ROLE_NAME/$ROLE_NAME/g;s/ACCOUNT_ID/$ACCOUNT_ID/g;s/BASE64ENCODED_AWS_PROVIDER_CREDS/$AWS_BASE64ENCODED_CREDS/g;s/EKS_WORKER_KEY_NAME/$EKS_WORKER_KEY_NAME/g;s/REGION/$REGION/g;s/RDS_SUBNET_GROUP/$RDS_SUBNET_GROUP/g;s/RDS_SECURITY_GROUP/$RDS_SECURITY_GROUP/g;" provider.yaml | kubectl create -f -

kubectl apply -f eks.yaml
kubectl apply -f rds.yaml
kubectl apply -f workload.yaml