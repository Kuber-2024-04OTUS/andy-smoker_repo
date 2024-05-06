minikube start --driver=docker # --mount --mount-string $(pwd)/volumes:/volumes

kubectl apply -f namespace.yaml
kubectl config set-context --current --namespace=homework
kubectl apply -f pod.yaml

sleep 20
kubectl port-forward pods/nginx 8000:8000 -n homework

curl localhost:8000