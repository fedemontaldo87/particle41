#!/usr/bin/env sh

set -e

terraform apply -auto-approve

printf "\nWaiting for the echo web server service... \n"
kubectl apply -f nodejs/deployment/microservice.yaml
sleep 30
kubectl apply -f nodejs/deployment/service.yaml
POD_NAME=`kubectl get pod | grep time | sed 's/ .*//'`
kubectl port-forward $POD_NAME  5000 >/dev/null 2>&1 & 

sleep 30
#printf "\nYou should see 'foo' as a reponse below (if you do the ingress is working):\n"
curl -i http://localhost:5000/time


