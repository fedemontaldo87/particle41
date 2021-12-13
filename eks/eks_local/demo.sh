#!/usr/bin/env sh

set -e

terraform apply -auto-approve

printf "\nWaiting for the echo web server service... \n"
kubectl apply -f nodejs/deployment/microservice.yaml
sleep 30

POD_NAME=`kubectl get pod | grep time | sed 's/ .*//'`
kubectl port-forward $POD_NAME  5000 >/dev/null 2>&1 & 

sleep 30
#printf "\nYou should see 'foo' as a reponse below (if you do the ingress is working):\n"
curl -i http://localhost:5000/time

 #!/usr/bin/env sh

set -e

terraform apply -auto-approve

printf "\nWaiting for the echo web server service... \n"
kubectl apply -f nodejs/deployment/microservice.yaml
sleep 10

POD_NAME=`kubectl get pod | grep time | sed 's/ .*//'`

kubectl port-forward $POD_NAME  5000

printf "\nchek time service deployment \n"
curl curl -i http://localhost:5000/time

printf "\nDestroy portforward  \n"

kiperf=$(ps -ef | grep 5000 | grep -v grep | awk '{print $2}')
# Kills all iperf or command line
kill -9 $kiperf

terraform destroy -auto-approve

