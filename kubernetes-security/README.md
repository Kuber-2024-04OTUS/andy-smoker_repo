### ДЗ 5 ###

## В процессе сделано:
- В манифест namespace.yaml добалены
  - ServiceAccount - monitoring
  - ServiceAccount - cd
  - Role - monitoring.role
  - RoleBinding - auth-role-binding для назначения аккаунту monitoring роли monitoring.role
  - ClusterRole - cluster.admin
  - ClusterRoleBinding - для назначения аккаунту cd роли cluster.admin
- В манифест deployment.yaml добален
  - serviceAccount monitoring для pod'ов nginx
  - Добавллен postStart который сохраняет вывод запроса к эндпоинту /metrics в /homework/metrics.html
- В манифест cm.yaml в конфиг nginx добавлен location /metrics для вывода файла /homework/metrics.html
- Создан манифест kubeconfig c аккаунтом cd 

## Как запустить проект и проверить работособность:
```./run.sh```

Вывод:
```
+ cd kubernetes-security
+ kubectl apply -f namespace.yaml
namespace/homework created
role.rbac.authorization.k8s.io/monitoring-role created
serviceaccount/monitoring created
serviceaccount/cd created
rolebinding.rbac.authorization.k8s.io/auth-role-binding created
clusterrole.rbac.authorization.k8s.io/cluster.admin unchanged
clusterrolebinding.rbac.authorization.k8s.io/cluster.admin.binding unchanged
+ kubectl get po -n homework
No resources found in homework namespace.
+ kubectl config set-context --current --namespace=homework
Context "minikube" modified.
+ kubectl apply -f cm.yaml -f storageClass.yaml -f pvc.yaml
configmap/nginx-conf created
configmap/homework-conf created
storageclass.storage.k8s.io/storage.class unchanged
persistentvolumeclaim/pvc1 created
+ sleep 5
+ kubectl apply -f deployment.yaml -f service.yaml -f ingress.yaml
deployment.apps/nginx created
service/service-nginx created
ingress.networking.k8s.io/ingress-nginx created
+ sleep 30
+ kubectl describe -f pvc.yaml
Name:          pvc1
Namespace:     homework
StorageClass:  storage.class
Status:        Bound
Volume:        pvc-be5b9076-17a9-4b8a-93a2-2d45bc6cede6
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: k8s.io/minikube-hostpath
               volume.kubernetes.io/storage-provisioner: k8s.io/minikube-hostpath
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      500m
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       nginx-7d6d54f7d6-4rxxr
               nginx-7d6d54f7d6-6cr9z
               nginx-7d6d54f7d6-nr8lq
Events:
  Type    Reason                 Age   From                                                                    Message
  ----    ------                 ----  ----                                                                    -------
  Normal  ExternalProvisioning   36s   persistentvolume-controller                                             waiting for a volume to be created, either by external provisioner "k8s.io/minikube-hostpath" or manually created by system administrator
  Normal  Provisioning           36s   k8s.io/minikube-hostpath_minikube_5b80c209-86e0-4c7a-a3a1-37ee1198fa11  External provisioner is provisioning volume for claim "homework/pvc1"
  Normal  ProvisioningSucceeded  36s   k8s.io/minikube-hostpath_minikube_5b80c209-86e0-4c7a-a3a1-37ee1198fa11  Successfully provisioned volume pvc-be5b9076-17a9-4b8a-93a2-2d45bc6cede6
+ kubectl get pvc
NAME   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc1   Bound    pvc-be5b9076-17a9-4b8a-93a2-2d45bc6cede6   500m       RWO            storage.class   36s
+ kubectl describe -f deployment.yaml
Name:                   nginx
Namespace:              homework
CreationTimestamp:      Sun, 02 Jun 2024 23:33:50 +0300
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 3 max surge
Pod Template:
  Labels:           app=nginx
  Service Account:  monitoring
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
NewReplicaSet:   nginx-7d6d54f7d6 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  30s   deployment-controller  Scaled up replica set nginx-7d6d54f7d6 to 3
+ kubectl get services -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.102.181.60   <none>        80:32526/TCP,443:30637/TCP   12d
ingress-nginx-controller-admission   ClusterIP   10.111.99.4     <none>        443/TCP                      12d
++ kubectl create token cd --duration=24h --namespace=homework
+ export TOKEN=...
++ kubectl config view --minify -o 'jsonpath={.clusters[0].cluster.server}'
+ export APISERVER=https://192.168.49.2:8443
+ APISERVER=https://192.168.49.2:8443
+ base64 --decode
++ kubectl get sa monitoring -n homework -o 'jsonpath={.secrets[0].name}'
+ kubectl get secret -n homework -o 'jsonpath={.data.ca\.crt}'
+ export CONTEXT=monitoring-context
+ CONTEXT=monitoring-context
+ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/inok/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Sun, 02 Jun 2024 15:46:38 MSK
        provider: minikube.sigs.k8s.io
        version: v1.26.0
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Sun, 02 Jun 2024 15:46:38 MSK
        provider: minikube.sigs.k8s.io
        version: v1.26.0
      name: context_info
    namespace: homework
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /home/inok/.minikube/profiles/minikube/client.crt
    client-key: /home/inok/.minikube/profiles/minikube/client.key
+ sleep 5
++ minikube ip
+ curl 192.168.49.2:80/homepage -H 'Host: homework.otus' -S -I
HTTP/1.1 404 Not Found
Date: Sun, 02 Jun 2024 20:34:25 GMT
Content-Type: text/html
Content-Length: 146
Connection: keep-alive

++ minikube ip
+ curl 192.168.49.2:80/conf/ -H 'Host: homework.otus'
<html>
<head><title>Index of /conf/</title></head>
<body>
<h1>Index of /conf/</h1><hr><pre><a href="../">../</a>
<a href="config1">config1</a>                                            02-Jun-2024 20:33                   6
<a href="config2">config2</a>                                            02-Jun-2024 20:33                   6
<a href="config3">config3</a>                                            02-Jun-2024 20:33                   6
</pre><hr></body>
</html>
++ minikube ip
+ curl 192.168.49.2:80/conf/config1 -H 'Host: homework.otus'
value1++ minikube ip
+ curl 192.168.49.2:80/metrics -H 'Host: homework.otus'
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {},
  "status": "Failure",
  "message": "forbidden: User \"system:serviceaccount:homework:monitoring\" cannot get path \"/metrics\"",
  "reason": "Forbidden",
  "details": {},
  "code": 403
}%   
```
