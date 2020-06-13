#!/bin/bash

kubectl apply -f wordpress-yamls/
sleep 20s
kubectl apply -f es-yamls/
sleep 20s
kubectl apply -f kibana-yamls/
sleep 20s
echo " Please wait until the loadbalancer is ready, check kubectl get svc"
