#!/bin/bash -xe
# minikube start --driver=docker # --mount --mount-string $(pwd)/volumes:/volumes
# minikube addons enable ingress
cd kubernetes-volumes || echo ''

kubectl apply -f namespace.yaml
kubectl get po -n homework
kubectl config set-context --current --namespace=homework
kubectl apply -f cm.yaml
kubectl apply -f storageClass.yaml
kubectl apply -f pvc.yaml
sleep 5
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml

sleep 30
kubectl describe -f pvc.yaml
kubectl get pvc
kubectl describe -f deployment.yaml
kubectl get services -n ingress-nginx
sleep 5

curl $(minikube ip):80/homepage -H "Host: homework.otus" -S -I
curl $(minikube ip):80/conf/ -H "Host: homework.otus"
curl $(minikube ip):80/conf/config1 -H "Host: homework.otus"
# kubectl exec -it $(kubectl get pod | awk -F ' ' '{print $1}' | tail -n 1) -- sh -c "ls -l /homework/conf"