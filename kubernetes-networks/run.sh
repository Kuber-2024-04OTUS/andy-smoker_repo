#!/bin/bash -xe
# minikube start --driver=docker # --mount --mount-string $(pwd)/volumes:/volumes
# minikube addons enable ingress
cd kubernetes-networks || echo ''

kubectl apply -f namespace.yaml
kubectl get po -n homework
kubectl config set-context --current --namespace=homework
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml

sleep 30
kubectl get services -n ingress-nginx
kubectl describe -f deployment.yaml
sleep 5

curl $(minikube ip):80 -H "Host: homework.otus" -S -I