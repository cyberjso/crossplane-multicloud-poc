#!/bin/bash

cd "$(dirname "$0")"

. ../env.sh

gcloud config set compute/zone $REGION
gcloud config set project $PROJECT_ID
gcloud container clusters create $K8S_CONTROL_PLANE_CLUSTER_NAME --num-nodes=1 --node-locations=$ZONES
gcloud container clusters get-credentials $K8S_CONTROL_PLANE_CLUSTER_NAME

#Enable services on GCP
gcloud --project $PROJECT_ID services enable container.googleapis.com
gcloud --project $PROJECT_ID services enable sqladmin.googleapis.com


#Init tiller (helm) on k8s
kubectl create -f rbac-config.yaml
helm init --service-account tiller

# INSTALL crossplane
helm repo add crossplane-alpha https://charts.crossplane.io/alpha
echo "Waitting until tiller POD is up and running"
sleep 2m 
helm install --name crossplane --namespace crossplane-system crossplane-alpha/crossplane


# Create a service account so, Crossplane can create objects using it
gcloud --project $PROJECT_ID iam service-accounts create crossplane-example --display-name "Crossplane - Multi-cloud POC"
export CONTROL_PANE_IAM_ROLE="crossplane-example@$PROJECT_ID.iam.gserviceaccount.com"
gcloud --project $PROJECT_ID iam service-accounts keys create --iam-account $CONTROL_PANE_IAM_ROLE key.json

# Adding GCP as a cloud provider
gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$CONTROL_PANE_IAM_ROLE" --role="roles/iam.serviceAccountUser"
gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$CONTROL_PANE_IAM_ROLE" --role="roles/cloudsql.admin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$CONTROL_PANE_IAM_ROLE" --role="roles/container.admin"
