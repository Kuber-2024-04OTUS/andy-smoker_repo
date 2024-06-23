#!/bin/bash -x

cd kubernetes-security || echo ''

CLUSTER_NAME=minikube

# Создание прастранства имён.
kubectl create --cluster ${CLUSTER_NAME} namespace homework
kubectl config set-context --current --namespace=homework

echo "ClusterIP: $(minikube ip)
curl $(minikube ip):80/homepage -H "Host: homework.otus" -S -I
curl $(minikube ip):80/conf/ -H "Host: homework.otus"
curl $(minikube ip):80/conf/config1 -H "Host: homework.otus"
curl $(minikube ip):80/metrics -H "Host: homework.otus"
" > templates/NOTES.txt

helm install homework ./ || helm upgrade homework ./

sleep 15
kubectl get --cluster ${CLUSTER_NAME} po
kubectl get --cluster ${CLUSTER_NAME} ingress
kubectl get --cluster ${CLUSTER_NAME} svc

