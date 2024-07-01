#!/bin/bash -x

CLUSTER_NAME=minikube

# Создание прастранства имён.
kubectl create --cluster ${CLUSTER_NAME} namespace homework
kubectl config set-context --current --namespace=homework

helm install homework ./ || helm upgrade homework ./

sleep 15
kubectl get --cluster ${CLUSTER_NAME} po
kubectl get --cluster ${CLUSTER_NAME} ingress
kubectl get --cluster ${CLUSTER_NAME} svc

