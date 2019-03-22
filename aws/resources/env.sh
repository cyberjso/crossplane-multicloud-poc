#!/bin/bash

export EKS_VPC=""
export EKS_SUBNETS=""
export EKS_SECURITY_GROUP=""
export ACCOUNT_ID=""
export ROLE_NAME="svc-eks-crossplane-poc"
export RDS_SECURITY_GROUP=""
export RDS_SUBNET_GROUP="rds-crossplane-subnets-multi-cloud-poc"
export AWS_BASE64ENCODED_CREDS="$(cat ~/.aws/credentials|base64|tr -d '\n')"
export EKS_WORKER_KEY_NAME="kp-crossplane-multi-cloud-poc"
export REGION="us-west-2"