#!/bin/bash

cd "$(dirname "$0")"

#Use this in order to validate resources are ok. STATUS should be READY
kubectl -n crossplane-system get providers.aws.crossplane.io -o custom-columns=NAME:.metadata.name,STATUS:.status.Conditions[0].Type,PROJECT-ID:.spec.projectID

# You should be able to see resources including from aws
kubectl get  resourceClass -n  crossplane-system

#Use this to check GKE cluster was created. State should be RUNNING
kubectl -n crossplane-system get ekscluster -o custom-columns=NAME:.metadata.name,STATE:.status.state,CLUSTERNAME:.status.clusterName,ENDPOINT:.status.endpoint,LOCATION:.spec.zone,CLUSTERCLASS:.spec.classRef.name,RECLAIMPOLICY:.spec.reclaimPolicy

# Use this in order to check RDS instance was launched properly
kubectl -n crossplane-system get rdsinstance -o custom-columns=NAME:.metadata.name,STATUS:.status.state,CLASS:.spec.classRef.name,VERSION:.spec.databaseVersion

#Use this in order to validate workload was deployed.  State should be RUNNING
kubectl -n default describe Workload

#Look at the load balancer and put that on your browser. You should be able to connect on the application
kubectl -n default  describe workload  demo-workload