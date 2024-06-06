#!/bin/bash -xe
# minikube start --driver=docker # --mount --mount-string $(pwd)/volumes:/volumes
# minikube addons enable ingress
cd kubernetes-security || echo ''

kubectl apply -f namespace.yaml
kubectl get po -n homework
kubectl config set-context --current --namespace=homework
kubectl apply -f cm.yaml -f storageClass.yaml -f pvc.yaml
sleep 5
kubectl apply -f deployment.yaml -f service.yaml -f ingress.yaml

sleep 30
kubectl describe -f pvc.yaml
kubectl get pvc
kubectl describe -f deployment.yaml
kubectl get services -n ingress-nginx

export TOKEN=$(kubectl create token cd --duration=24h --namespace=homework)
export APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
kubectl get secret $(kubectl get sa monitoring -n homework -o jsonpath='{.secrets[0].name}') -n homework -o jsonpath='{.data.ca\.crt}' | base64 --decode > ca.crt
export CONTEXT="monitoring-context"
kubectl config view

sleep 5

curl $(minikube ip):80/homepage -H "Host: homework.otus" -S -I
curl $(minikube ip):80/conf/ -H "Host: homework.otus"
curl $(minikube ip):80/conf/config1 -H "Host: homework.otus"
curl $(minikube ip):80/metrics -H "Host: homework.otus" 1> metrics.txt
