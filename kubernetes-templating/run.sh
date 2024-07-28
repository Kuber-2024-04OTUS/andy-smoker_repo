#!/bin/bash -x

cd kubernetes-templating || echo ''

workDir=$(pwd)

cd homework-chart && /run.sh

cd ${workDir}

CLUSTER_NAME=minikube

helmfile apply -f helmfile.yaml 

sleep 15
echo "---------dev-----------"
kubectl get --cluster ${CLUSTER_NAME} -n dev po

echo "---------prod-----------"
kubectl get --cluster ${CLUSTER_NAME} -n prod po


