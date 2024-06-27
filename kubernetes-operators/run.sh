#!/bin/bash -xe
# minikube start --driver=docker # --mount --mount-string $(pwd)/volumes:/volumes
# minikube addons enable ingress
cd kubernetes-operators || echo ''

CLUSTER_NAME=minikube

kubectl apply --cluster ${CLUSTER_NAME} -f namespace.yaml
kubectl config set-context --current --namespace=homework
kubectl apply --cluster ${CLUSTER_NAME}  -f crd.yaml -f deployment.yaml -f custom.yaml

sleep 5
kubectl get mysql
