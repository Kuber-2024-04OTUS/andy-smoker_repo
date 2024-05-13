# Репозиторий для выполнения домашних заданий курса "Инфраструктурная платформа на основе Kubernetes-2024-02" 

### ДЗ №2 ###
## В процессе сделано:
- Создан манифест namespace.yaml для namespace с именем homework
- Создан манифест deployment.yaml
  - Создаётся в namespace homework
  - Запускает 3 пода
  - Имеетreadiness пробу, которая проверяет наличие файла /homework/index.html
  - Стратегия обновления RollingUpdate, с maxUnavailable: 1
  - Так же Deployment запускаетя на нодах с тэгом homework=true

## Как запустить проект и проверить проверить работоспособность:
```./kubernetes-controllers/run.sh```

Вывод:
```
namespace/homework unchanged
Context "minikube" modified.
configmap/nginx-conf unchanged
deployment.apps/nginx created
Forwarding from 127.0.0.1:8000 -> 8000
Forwarding from [::1]:8000 -> 8000
Handling connection for 8000
HTTP/1.1 200 OK
Server: nginx/1.26.0
Date: Mon, 13 May 2024 21:59:38 GMT
Content-Type: text/html
Content-Length: 149331
Last-Modified: Mon, 13 May 2024 21:59:16 GMT
Connection: keep-alive
ETag: "66428d34-24753"
Accept-Ranges: bytes
```