# Репозиторий для выполнения домашних заданий курса "Инфраструктурная платформа на основе Kubernetes-2024-02" 

ДЗ №1

## В процессе сделано:
 - Установлен minicube и kubectl
 - Написан манифест  namespace.yaml для создания namespace 
 - Написан манифест configmap.yaml с наконфигурацие nginx
 - Написан манифест pod.yaml

## Как запустить проект и проверить работособность:
```./run.sh```

Вывод:
```
namespace/homework created
Context "minikube" modified.
configmap/nginx-conf created
pod/nginx created
Forwarding from 127.0.0.1:8000 -> 8000
Forwarding from [::1]:8000 -> 8000
Handling connection for 8000
HTTP/1.1 200 OK
Server: nginx/1.26.0
Date: Mon, 13 May 2024 22:15:57 GMT
Content-Type: text/html
Content-Length: 149331
Last-Modified: Mon, 13 May 2024 22:15:35 GMT
Connection: keep-alive
ETag: "66429107-24753"
Accept-Ranges: bytes
```