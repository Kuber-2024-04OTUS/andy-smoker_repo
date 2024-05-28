### ДЗ №4 ###

## В процессе сделано:
- Создан манифест storageClass.yaml 
  - объект storageClass 
    - provisioner k8s.io/minikube-hostpath
    - reclaimPolicy Retain
- Создан манифест pvc.yaml
  - Запрашивает хранилище описанное в storageClass.yaml
- Создан манифест cm.yaml
  - Объект configMap nginx-conf - настройки nginx
  - Объект configMap homework-conf с спроизволыми ключами произволных значений
- Изменена спейцификация в манифесте deployment.yaml 
  - configMap из предыдущего пунка монтируется в директория /homework/conf

## Как запустить проект и проверить работособность:
```./run.sh```

Вывод:
```
+ cd kubernetes-volumes
./run.sh: line 4: cd: kubernetes-volumes: No such file or directory
+ echo ''

+ kubectl apply -f namespace.yaml
namespace/homework created
+ kubectl get po -n homework
No resources found in homework namespace.
+ kubectl config set-context --current --namespace=homework
Context "minikube" modified.
+ kubectl apply -f cm.yaml
configmap/nginx-conf created
configmap/homework-conf created
+ kubectl apply -f storageClass.yaml
storageclass.storage.k8s.io/storage.class unchanged
+ kubectl apply -f pvc.yaml
persistentvolumeclaim/pvc1 created
+ sleep 5
+ kubectl apply -f deployment.yaml
deployment.apps/nginx created
+ kubectl apply -f service.yaml
service/service-nginx created
+ kubectl apply -f ingress.yaml
ingress.networking.k8s.io/ingress-nginx created
+ sleep 30
+ kubectl describe -f pvc.yaml
Name:          pvc1
Namespace:     homework
StorageClass:  storage.class
Status:        Bound
Volume:        pvc-251b8a31-205e-480a-b752-71c8b68ed81e
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: k8s.io/minikube-hostpath
               volume.kubernetes.io/storage-provisioner: k8s.io/minikube-hostpath
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      500m
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       nginx-5f75c4bc8f-4cqpb
               nginx-5f75c4bc8f-66thk
               nginx-5f75c4bc8f-nl9rk
Events:
  Type    Reason                 Age   From                                                                    Message
  ----    ------                 ----  ----                                                                    -------
  Normal  ExternalProvisioning   36s   persistentvolume-controller                                             waiting for a volume to be created, either by external provisioner "k8s.io/minikube-hostpath" or manually created by system administrator
  Normal  Provisioning           36s   k8s.io/minikube-hostpath_minikube_051e832f-2785-43b3-bfa4-0e2d9a1f5663  External provisioner is provisioning volume for claim "homework/pvc1"
  Normal  ProvisioningSucceeded  36s   k8s.io/minikube-hostpath_minikube_051e832f-2785-43b3-bfa4-0e2d9a1f5663  Successfully provisioned volume pvc-251b8a31-205e-480a-b752-71c8b68ed81e
+ kubectl get pvc
NAME   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc1   Bound    pvc-251b8a31-205e-480a-b752-71c8b68ed81e   500m       RWO            storage.class   36s
+ kubectl describe -f deployment.yaml
Name:                   nginx
Namespace:              homework
CreationTimestamp:      Sun, 26 May 2024 22:59:19 +0300
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
      /homework/conf from homework-conf (rw)
  Volumes:
   nginx-conf:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      nginx-conf
    Optional:  false
   homework-conf:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      homework-conf
    Optional:  false
   homework:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  pvc1
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-5f75c4bc8f (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  30s   deployment-controller  Scaled up replica set nginx-5f75c4bc8f to 3
+ kubectl get services -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.102.181.60   <none>        80:32526/TCP,443:30637/TCP   5d22h
ingress-nginx-controller-admission   ClusterIP   10.111.99.4     <none>        443/TCP                      5d22h
+ sleep 5
++ minikube ip
+ curl 192.168.49.2:80/homepage -H 'Host: homework.otus' -S -I
HTTP/1.1 200 OK
Date: Sun, 26 May 2024 19:59:54 GMT
Content-Type: text/html
Content-Length: 149794
Connection: keep-alive
Last-Modified: Sun, 26 May 2024 19:59:25 GMT
ETag: "6653949d-24922"
Accept-Ranges: bytes
++ minikube ip
+ curl 192.168.49.2:80/conf/ -H 'Host: homework.otus'
<html>
<head><title>Index of /conf/</title></head>
<body>
<h1>Index of /conf/</h1><hr><pre><a href="../">../</a>
<a href="config1">config1</a>                                            26-May-2024 21:31                   6
<a href="config2">config2</a>                                            26-May-2024 21:31                   6
<a href="config3">config3</a>                                            26-May-2024 21:31                   6
</pre><hr></body>
</html>
++ minikube ip
+ curl 192.168.49.2:80/conf/config1 -H 'Host: homework.otus'
value1%
```
