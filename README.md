# Репозиторий для выполнения домашних заданий курса "Инфраструктурная платформа на основе Kubernetes-2024-02" 

### ДЗ №1 ###

## В процессе сделано:
 - Установлен minicube и kubectl
 - Написан манифест  namespace.yaml для создания namespace 
 - Написан манифест configmap.yaml с наконфигурацие nginx
 - Написан манифест pod.yaml

## Как запустить проект и проверить работособность:
```./run.sh```

Вывод:
```
+ kubectl apply -f namespace.yaml
namespace/homework unchanged
+ kubectl get po -n homework
NAME    READY   STATUS    RESTARTS      AGE
nginx   1/1     Running   1 (23h ago)   23h
+ kubectl config set-context --current --namespace=homework
Context "minikube" modified.
+ kubectl apply -f configmap.yaml
configmap/nginx-conf unchanged
+ kubectl apply -f pod.yaml
pod/nginx configured
+ timeout 10 kubectl port-forward pods/nginx 8000:8000 -n homework
Forwarding from 127.0.0.1:8000 -> 8000
Forwarding from [::1]:8000 -> 8000
+ curl localhost:8000 -S -I
Handling connection for 8000
HTTP/1.1 200 OK
Server: nginx/1.26.0
Date: Tue, 14 May 2024 22:06:44 GMT
Content-Type: text/html
Content-Length: 149303
Last-Modified: Tue, 14 May 2024 22:05:36 GMT
Connection: keep-alive
ETag: "6643e030-24737"
Accept-Ranges: bytes
```

### [ДЗ №2](kubernetes-controllers/README.md)
---
### [ДЗ №3](kubernetes-networks/README.md)
---
### [ДЗ №4](kubernetes-volumes/README.md)
