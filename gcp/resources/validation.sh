#!/bin/bash

#Use this in order to validate resources are ok. STATUS should be READY
kubectl -n crossplane-system get providers.gcp.crossplane.io -o custom-columns=NAME:.metadata.name,STATUS:.status.Conditions[0].Type,PROJECT-ID:.spec.projectID

## This command is for validation only, look at the status and check if it looks good, otherwise do not proceed
kubectl -n crossplane-system describe providers.aws.crossplane.io

# You should be able to see resources including from GCP
kubectl get  resourceClass -n  crossplane-system

#Use this to check GKE cluster was created. State should be RUNNING
kubectl -n crossplane-system get gkecluster -o custom-columns=NAME:.metadata.name,STATE:.status.state,CLUSTERNAME:.status.clusterName,ENDPOINT:.status.endpoint,LOCATION:.spec.zone,CLUSTERCLASS:.spec.classRef.name,RECLAIMPOLICY:.spec.reclaimPolicy

#Use this in order to validate workload was deployed.  State should be RUNNING
kubectl -n default describe Workload


#Look at the load balancer and put that on your browser. You should be able to connect on the application
kubectl -n default  describe workload  demo