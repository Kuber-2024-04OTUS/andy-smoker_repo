### ДЗ №3 ###

## В процессе сделано:
 - Изменена readinessProbe на httpGet
 - Создан манифест service.yaml
   - Описан сервис service-nginx который перенаправляет трафик на поды
 - Создан манифест ingress.yaml
   - объект типа ingress перенаправляет http запросы к хосту homework.otus на сервис service-nginx

## Как запустить проект и проверить работособность:
```./run.sh```

Вывод:
```
+ cd kubernetes-networks
+ kubectl apply -f namespace.yaml
namespace/homework created
+ kubectl get po -n homework
No resources found in homework namespace.
+ kubectl config set-context --current --namespace=homework
Context "minikube" modified.
+ kubectl apply -f deployment.yaml
configmap/nginx-conf created
deployment.apps/nginx created
+ kubectl apply -f service.yaml
service/service-nginx created
+ kubectl apply -f ingress.yaml
ingress.networking.k8s.io/ingress-nginx created
+ sleep 30
+ kubectl get services -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.102.181.60   <none>        80:32526/TCP,443:30637/TCP   11m
ingress-nginx-controller-admission   ClusterIP   10.111.99.4     <none>        443/TCP                      11m
+ kubectl describe -f deployment.yaml
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
CreationTimestamp:      Tue, 21 May 2024 00:48:00 +0300
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
    Readiness:    http-get http://:8000/index.html delay=5s timeout=1s period=15s #success=1 #failure=3
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
NewReplicaSet:   nginx-85ccdf8b87 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  31s   deployment-controller  Scaled up replica set nginx-85ccdf8b87 to 3
+ sleep 5
++ minikube ip
+ curl 192.168.49.2:80 -H 'Host: homework.otus' -S -I
HTTP/1.1 200 OK
Date: Mon, 20 May 2024 21:48:36 GMT
Content-Type: text/html
Content-Length: 149551
Connection: keep-alive
Last-Modified: Mon, 20 May 2024 21:48:06 GMT
ETag: "664bc516-2482f"
Accept-Ranges: bytes
```
