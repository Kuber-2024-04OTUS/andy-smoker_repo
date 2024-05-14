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
+ kubectl apply -f kubernetes-controllers/namespace.yaml
namespace/homework created
+ kubectl get po -n homework
No resources found in homework namespace.
+ kubectl config set-context --current --namespace=homework
Context "minikube" modified.
+ kubectl apply -f kubernetes-controllers/deployment.yaml
configmap/nginx-conf created
deployment.apps/nginx created
+ sleep 20
+ kubectl describe -f kubernetes-controllers/deployment.yaml
  Name:         nginx-conf
  Namespace:    homework
  Labels:       <none>
  Annotations:  <none>

  Data
  ====
  nginx.conf:
  ----
  server {
    location / {
        root /homework;
        try_files $uri $uri/ /index.html;
    }
    listen 8000;
  }


  BinaryData
  ====

  Events:  <none>


  Name:                   nginx
  Namespace:              homework
  CreationTimestamp:      Wed, 15 May 2024 01:20:01 +0300
  Labels:                 <none>
  Annotations:            deployment.kubernetes.io/revision: 1
  Selector:               app=nginx
  Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
  StrategyType:           RollingUpdate
  MinReadySeconds:        0
  RollingUpdateStrategy:  1 max unavailable, 3 max surge
  Pod Template:
    Labels:  app=nginx
    Init Containers:
     busybox:
      Image:      busybox
      Port:       <none>
      Host Port:  <none>
      Command:
        sh
        -c
        wget https://ru.wikipedia.org/wiki/Hello,_world! -O /init/index.html
      Limits:
        cpu:        500m
        memory:     128Mi
      Environment:  <none>
      Mounts:
        /init from homework (rw)
    Containers:
     nginx:
      Image:      nginx:stable
      Port:       8000/TCP
      Host Port:  0/TCP
      Limits:
        cpu:        500m
        memory:     128Mi
      Readiness:    exec [sh -c ls /homework/index.html] delay=5s timeout=1s period=15s #success=1 #failure=3
      Environment:  <none>
      Mounts:
        /etc/nginx/conf.d/ from nginx-conf (rw)
        /homework from homework (rw)
    Volumes:
     nginx-conf:
      Type:      ConfigMap (a volume populated by a ConfigMap)
      Name:      nginx-conf
      Optional:  false
     homework:
      Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
      Medium:     
      SizeLimit:  500Mi
  Conditions:
    Type           Status  Reason
    ----           ------  ------
    Available      True    MinimumReplicasAvailable
    Progressing    True    NewReplicaSetAvailable
  OldReplicaSets:  <none>
  NewReplicaSet:   nginx-854f667996 (3/3 replicas created)
  Events:
    Type    Reason             Age   From                   Message
    ----    ------             ----  ----                   -------
    Normal  ScalingReplicaSet  20s   deployment-controller  Scaled up replica set nginx-854f667996 to 3
+ timeout 10 kubectl port-forward deployment/nginx 8000:8000 -n homework
+ sleep 5
Forwarding from 127.0.0.1:8000 -> 8000
Forwarding from [::1]:8000 -> 8000
+ curl localhost:8000 -S -I
Handling connection for 8000
HTTP/1.1 200 OK
Server: nginx/1.26.0
Date: Tue, 14 May 2024 22:20:26 GMT
Content-Type: text/html
Content-Length: 149303
Last-Modified: Tue, 14 May 2024 22:20:04 GMT
Connection: keep-alive
ETag: "6643e394-24737"
Accept-Ranges: bytes
```