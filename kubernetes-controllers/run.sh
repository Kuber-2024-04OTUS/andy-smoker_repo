#!/bin/bash -xe
# minikube start --driver=docker # --mount --mount-string $(pwd)/volumes:/volumes

kubectl apply -f kubernetes-controllers/namespace.yaml
kubectl get po -n homework
kubectl config set-context --current --namespace=homework
kubectl apply -f kubernetes-controllers/deployment.yaml

sleep 20
kubectl describe -f kubernetes-controllers/deployment.yaml
timeout 10 kubectl port-forward deployment/nginx 8000:8000 -n homework &
sleep 5

curl localhost:8000 -S -I