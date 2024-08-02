#!/bin/bash -xe
# minikube start --driver=docker # --mount --mount-string $(pwd)/volumes:/volumes
# minikube addons enable ingress
cd kubernetes-operators || echo ''

CLUSTER_NAME=minikube

kubectl apply --cluster ${CLUSTER_NAME} -f namespace.yaml -f crd.yaml
kubectl config set-context --current --namespace=homework
kubectl apply --cluster ${CLUSTER_NAME} -f deployment.yaml -f custom.yaml

sleep 5
kubectl get -f crd.yaml
kubectl get -f deployment.yaml
kubectl get -f custom.yaml
kubectl get pv


