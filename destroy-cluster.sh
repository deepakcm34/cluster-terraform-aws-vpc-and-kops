#!/bin/bash

clustername=$(cat clustername.txt)
state_store=$(cat stores.txt)

kubectl delete -f wordpress-yamls/
sleep 5s
kubectl delete -f es-yamls/
sleep 5s
kubectl delete -f kibana-yamls/
sleep 5s

kops delete cluster --name $clustername --state $state_store --yes

sleep 10s

cd aws-vpc/

terraform destroy --var-file example.tfvars -auto-approve

sleep 10s

cd ..

cd aws-s3/

terraform destroy --var-file s3.tfvars -auto-approve

cd ..
