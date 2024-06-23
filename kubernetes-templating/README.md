# Выполнено ДЗ №6

 - [ ] Основное ДЗ
 - [ ] Задание со *

## В процессе сделано:
- Задание 1
  - В volume.yaml вынесены
    - Имена объектов
    - Путь и тэг для образов
    - readinessProbe включется/выключется параментром .Values.readinessProbe.nginx.enabled
    - В NOTEST.txt из переменной .Values.ingressIP выводится IP на который можно обратиться чтоб выполнить запрос
  - Добавлена зависимость чата от charts.bitnami.com/bitnami/redis
- Задание 2
  - Создан helmfile.yaml
  - namespace prod
    - Установка namespace prod
    - Подимается 5 брокеров
    - Версия кафки 3.5.2
    - Аутентификация SASL_PLAINTEXT
  - namespace dev
    - Установка namespace dev
    - Подимается 1 брокера
    - Версия кафки latest
    - Аутентификация PLAINTEXT и отключена авторицация для подключения к кластеру

## Как запустить проект и проверить работособность:
```./run.sh```

Вывод Задание 1:
```
+ CLUSTER_NAME=minikube
+ kubectl create --cluster minikube namespace homework
Error from server (AlreadyExists): namespaces "homework" already exists
+ kubectl config set-context --current --namespace=homework
Context "minikube" modified.

+ helm install homework ./
Error: INSTALLATION FAILED: cannot re-use a name that is still in use
+ helm upgrade homework ./
Release "homework" has been upgraded. Happy Helming!
NAME: homework
LAST DEPLOYED: Sun Jun 23 15:53:41 2024
NAMESPACE: homework
STATUS: deployed
REVISION: 15
TEST SUITE: None
NOTES:
```
echo "ClusterIP: 192.168.49.2
curl 192.168.49.2:80/homepage -H Host: homework.otus -S -I
curl 192.168.49.2:80/conf/ -H Host: homework.otus
curl 192.168.49.2:80/conf/config1 -H Host: homework.otus
curl 192.168.49.2:80/metrics -H Host: homework.otus"
```
+ sleep 15
+ kubectl get --cluster minikube po
NAME                        READY   STATUS              RESTARTS   AGE
homework-redis-master-0     0/1     ContainerCreating   0          16s
homework-redis-replicas-0   0/1     ContainerCreating   0          16s
nginx-5d86454567-2qzk7      0/1     Init:Error          0          16s
nginx-5d86454567-dgm29      0/1     Init:Error          0          16s
nginx-5d86454567-h9lpx      0/1     Init:Error          0          16s
nginx-69dd8695cd-ddqd5      1/1     Running             0          40h
nginx-69dd8695cd-jdx7s      1/1     Running             0          40h
+ kubectl get --cluster minikube ingress
NAME            CLASS   HOSTS           ADDRESS        PORTS   AGE
ingress-nginx   nginx   homework.otus   192.168.49.2   80      40h
+ kubectl get --cluster minikube svc
NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
homework-redis-headless   ClusterIP   None            <none>        6379/TCP   16s
homework-redis-master     ClusterIP   10.100.157.85   <none>        6379/TCP   16s
homework-redis-replicas   ClusterIP   10.108.25.209   <none>        6379/TCP   16s
nginx                     ClusterIP   10.108.231.35   <none>        8000/TCP   40h
```
Вывод Задание 2:
```

Comparing release=kafka-dev, chart=bitnami/kafka
********************

	Release was not present in Helm.  Diff will show entire contents as new.

********************
dev, kafka-dev, Service (v1) has been added:
- 
+ # Source: kafka/templates/svc.yaml
+ apiVersion: v1
+ kind: Service
+ metadata:
+   name: kafka-dev
+   namespace: "dev"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-dev
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+ spec:
+   type: ClusterIP
+   sessionAffinity: None
+   ports:
+     - name: tcp-client
+       port: 9092
+       protocol: TCP
+       targetPort: kafka-client
+       nodePort: null
+   selector:
+     app.kubernetes.io/name: kafka
+     app.kubernetes.io/instance: kafka-dev
+     app.kubernetes.io/component: kafka
dev, kafka-dev, ServiceAccount (v1) has been added:
- 
+ # Source: kafka/templates/serviceaccount.yaml
+ apiVersion: v1
+ kind: ServiceAccount
+ metadata:
+   name: kafka-dev
+   namespace: "dev"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-dev
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+   annotations:
+ automountServiceAccountToken: true
dev, kafka-dev, StatefulSet (apps) has been added:
- 
+ # Source: kafka/templates/statefulset.yaml
+ apiVersion: apps/v1
+ kind: StatefulSet
+ metadata:
+   name: kafka-dev
+   namespace: "dev"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-dev
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+ spec:
+   podManagementPolicy: Parallel
+   replicas: 1
+   selector:
+     matchLabels:
+       app.kubernetes.io/name: kafka
+       app.kubernetes.io/instance: kafka-dev
+       app.kubernetes.io/component: kafka
+   serviceName: kafka-dev-headless
+   updateStrategy:
+     rollingUpdate: {}
+     type: RollingUpdate
+   template:
+     metadata:
+       labels:
+         app.kubernetes.io/name: kafka
+         helm.sh/chart: kafka-23.0.1
+         app.kubernetes.io/instance: kafka-dev
+         app.kubernetes.io/managed-by: Helm
+         app.kubernetes.io/component: kafka
+       annotations:
+     spec:
+       
+       hostNetwork: false
+       hostIPC: false
+       affinity:
+         podAffinity:
+           
+         podAntiAffinity:
+           preferredDuringSchedulingIgnoredDuringExecution:
+             - podAffinityTerm:
+                 labelSelector:
+                   matchLabels:
+                     app.kubernetes.io/name: kafka
+                     app.kubernetes.io/instance: kafka-dev
+                     app.kubernetes.io/component: kafka
+                 topologyKey: kubernetes.io/hostname
+               weight: 1
+         nodeAffinity:
+           
+       securityContext:
+         fsGroup: 1001
+       serviceAccountName: kafka-dev
+       containers:
+         - name: kafka
+           image: docker.io/bitnami/kafka:latest
+           imagePullPolicy: "IfNotPresent"
+           securityContext:
+             allowPrivilegeEscalation: false
+             runAsNonRoot: true
+             runAsUser: 1001
+           command:
+             - /scripts/setup.sh
+           env:
+             - name: BITNAMI_DEBUG
+               value: "false"
+             - name: MY_POD_IP
+               valueFrom:
+                 fieldRef:
+                   fieldPath: status.podIP
+             - name: MY_POD_NAME
+               valueFrom:
+                 fieldRef:
+                   fieldPath: metadata.name
+             - name: KAFKA_CFG_ZOOKEEPER_CONNECT
+               value: 
+             - name: KAFKA_INTER_BROKER_LISTENER_NAME
+               value: "INTERNAL"
+             - name: KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP
+               value: "INTERNAL:PLAINTEXT,CLIENT:PLAINTEXT,CONTROLLER:PLAINTEXT"
+             - name: KAFKA_CFG_LISTENERS
+               value: "INTERNAL://:9094,CLIENT://:9092,CONTROLLER://:9093"
+             - name: KAFKA_CFG_ADVERTISED_LISTENERS
+               value: "INTERNAL://$(MY_POD_NAME).kafka-dev-headless.dev.svc.cluster.local:9094,CLIENT://$(MY_POD_NAME).kafka-dev-headless.dev.svc.cluster.local:9092"
+             - name: ALLOW_PLAINTEXT_LISTENER
+               value: "yes"
+             - name: KAFKA_ZOOKEEPER_PROTOCOL
+               value: PLAINTEXT
+             - name: KAFKA_VOLUME_DIR
+               value: "/bitnami/kafka"
+             - name: KAFKA_LOG_DIR
+               value: "/opt/bitnami/kafka/logs"
+             - name: KAFKA_CFG_DELETE_TOPIC_ENABLE
+               value: "false"
+             - name: KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE
+               value: "true"
+             - name: KAFKA_HEAP_OPTS
+               value: "-Xmx1024m -Xms1024m"
+             - name: KAFKA_CFG_LOG_FLUSH_INTERVAL_MESSAGES
+               value: "10000"
+             - name: KAFKA_CFG_LOG_FLUSH_INTERVAL_MS
+               value: "1000"
+             - name: KAFKA_CFG_LOG_RETENTION_BYTES
+               value: "1073741824"
+             - name: KAFKA_CFG_LOG_RETENTION_CHECK_INTERVAL_MS
+               value: "300000"
+             - name: KAFKA_CFG_LOG_RETENTION_HOURS
+               value: "168"
+             - name: KAFKA_CFG_MESSAGE_MAX_BYTES
+               value: "1000012"
+             - name: KAFKA_CFG_LOG_SEGMENT_BYTES
+               value: "1073741824"
+             - name: KAFKA_CFG_LOG_DIRS
+               value: "/bitnami/kafka/data"
+             - name: KAFKA_CFG_DEFAULT_REPLICATION_FACTOR
+               value: "1"
+             - name: KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR
+               value: "1"
+             - name: KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR
+               value: "1"
+             - name: KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR
+               value: "1"
+             - name: KAFKA_CFG_NUM_IO_THREADS
+               value: "8"
+             - name: KAFKA_CFG_NUM_NETWORK_THREADS
+               value: "3"
+             - name: KAFKA_CFG_NUM_PARTITIONS
+               value: "1"
+             - name: KAFKA_CFG_NUM_RECOVERY_THREADS_PER_DATA_DIR
+               value: "1"
+             - name: KAFKA_CFG_SOCKET_RECEIVE_BUFFER_BYTES
+               value: "102400"
+             - name: KAFKA_CFG_SOCKET_REQUEST_MAX_BYTES
+               value: "104857600"
+             - name: KAFKA_CFG_SOCKET_SEND_BUFFER_BYTES
+               value: "102400"
+             - name: KAFKA_CFG_ZOOKEEPER_CONNECTION_TIMEOUT_MS
+               value: "6000"
+             - name: KAFKA_CFG_AUTHORIZER_CLASS_NAME
+               value: ""
+             - name: KAFKA_CFG_ALLOW_EVERYONE_IF_NO_ACL_FOUND
+               value: "true"
+             - name: KAFKA_CFG_SUPER_USERS
+               value: "User:admin"
+             - name: KAFKA_ENABLE_KRAFT
+               value: "true"
+             - name: KAFKA_KRAFT_CLUSTER_ID
+               value: "kafka_cluster_id_test1"
+             - name: KAFKA_CFG_PROCESS_ROLES
+               value: "broker,controller"
+             - name: KAFKA_CFG_CONTROLLER_LISTENER_NAMES
+               value: "CONTROLLER"
+           ports:
+             - name: kafka-client
+               containerPort: 9092
+             - name: kafka-internal
+               containerPort: 9094
+             - name: kafka-ctlr
+               containerPort: 9093
+           livenessProbe:
+             failureThreshold: 3
+             initialDelaySeconds: 10
+             periodSeconds: 10
+             successThreshold: 1
+             timeoutSeconds: 5
+             tcpSocket:
+               port: kafka-client
+           readinessProbe:
+             failureThreshold: 6
+             initialDelaySeconds: 5
+             periodSeconds: 10
+             successThreshold: 1
+             timeoutSeconds: 5
+             tcpSocket:
+               port: kafka-client
+           resources:
+             limits: {}
+             requests: {}
+           volumeMounts:
+             - name: data
+               mountPath: /bitnami/kafka
+             - name: logs
+               mountPath: /opt/bitnami/kafka/logs
+             - name: scripts
+               mountPath: /scripts/setup.sh
+               subPath: setup.sh
+       volumes:
+         - name: scripts
+           configMap:
+             name: kafka-dev-scripts
+             defaultMode: 0755
+         - name: logs
+           emptyDir: {}
+   volumeClaimTemplates:
+     - metadata:
+         name: data
+       spec:
+         accessModes:
+           - "ReadWriteOnce"
+         resources:
+           requests:
+             storage: "8Gi"
dev, kafka-dev-headless, Service (v1) has been added:
- 
+ # Source: kafka/templates/svc-headless.yaml
+ apiVersion: v1
+ kind: Service
+ metadata:
+   name: kafka-dev-headless
+   namespace: "dev"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-dev
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+ spec:
+   type: ClusterIP
+   clusterIP: None
+   publishNotReadyAddresses: false
+   ports:
+     - name: tcp-client
+       port: 9092
+       protocol: TCP
+       targetPort: kafka-client
+     - name: tcp-internal
+       port: 9094
+       protocol: TCP
+       targetPort: kafka-internal
+     - name: tcp-controller
+       protocol: TCP
+       port: 9093
+       targetPort: kafka-ctlr
+   selector:
+     app.kubernetes.io/name: kafka
+     app.kubernetes.io/instance: kafka-dev
+     app.kubernetes.io/component: kafka
dev, kafka-dev-scripts, ConfigMap (v1) has been added:
+ # Source: kafka/templates/scripts-configmap.yaml
+ apiVersion: v1
+ kind: ConfigMap
+ metadata:
+   name: kafka-dev-scripts
+   namespace: "dev"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-dev
+     app.kubernetes.io/managed-by: Helm
+ data:
+   setup.sh: |-
+     #!/bin/bash
+ 
+     ID="${MY_POD_NAME#"kafka-dev-"}"
+     # If process.roles is not set at all, it is assumed to be in ZooKeeper mode.
+     # https://kafka.apache.org/documentation/#kraft_role
+ 
+     if [[ -f "/bitnami/kafka/data/meta.properties" ]]; then
+         if [[ $KAFKA_CFG_PROCESS_ROLES == "" ]]; then
+             export KAFKA_CFG_BROKER_ID="$(grep "broker.id" "/bitnami/kafka/data/meta.properties" | awk -F '=' '{print $2}')"
+         else
+             export KAFKA_CFG_NODE_ID="$(grep "node.id" "/bitnami/kafka/data/meta.properties" | awk -F '=' '{print $2}')"
+         fi
+     else
+         if [[ $KAFKA_CFG_PROCESS_ROLES == "" ]]; then
+             export KAFKA_CFG_BROKER_ID="$((ID + 0))"
+         else
+             export KAFKA_CFG_NODE_ID="$((ID + 0))"
+         fi
+     fi
+ 
+     if [[ $KAFKA_CFG_PROCESS_ROLES == *"controller"* && -z $KAFKA_CFG_CONTROLLER_QUORUM_VOTERS ]]; then
+         node_id=0
+         pod_id=0
+         while :
+         do
+             VOTERS="${VOTERS}$node_id@kafka-dev-$pod_id.kafka-dev-headless.dev.svc.cluster.local:9093"
+             node_id=$(( $node_id + 1 ))
+             pod_id=$(( $pod_id + 1 ))
+             if [[ $pod_id -ge 1 ]]; then
+                 break
+             else
+                 VOTERS="$VOTERS,"
+             fi
+         done
+         export KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=$VOTERS
+     fi
+ 
+     # Configure zookeeper client

+     exec /entrypoint.sh /run.sh

Comparing release=kafka-prod, chart=bitnami/kafka
********************

	Release was not present in Helm.  Diff will show entire contents as new.

********************
prod, kafka-prod, Service (v1) has been added:
- 
+ # Source: kafka/templates/svc.yaml
+ apiVersion: v1
+ kind: Service
+ metadata:
+   name: kafka-prod
+   namespace: "prod"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+ spec:
+   type: ClusterIP
+   sessionAffinity: None
+   ports:
+     - name: tcp-client
+       port: 9092
+       protocol: TCP
+       targetPort: kafka-client
+       nodePort: null
+   selector:
+     app.kubernetes.io/name: kafka
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/component: kafka
prod, kafka-prod, ServiceAccount (v1) has been added:
- 
+ # Source: kafka/templates/serviceaccount.yaml
+ apiVersion: v1
+ kind: ServiceAccount
+ metadata:
+   name: kafka-prod
+   namespace: "prod"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+   annotations:
+ automountServiceAccountToken: true
prod, kafka-prod, StatefulSet (apps) has been added:
- 
+ # Source: kafka/templates/statefulset.yaml
+ apiVersion: apps/v1
+ kind: StatefulSet
+ metadata:
+   name: kafka-prod
+   namespace: "prod"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+ spec:
+   podManagementPolicy: Parallel
+   replicas: 5
+   selector:
+     matchLabels:
+       app.kubernetes.io/name: kafka
+       app.kubernetes.io/instance: kafka-prod
+       app.kubernetes.io/component: kafka
+   serviceName: kafka-prod-headless
+   updateStrategy:
+     rollingUpdate: {}
+     type: RollingUpdate
+   template:
+     metadata:
+       labels:
+         app.kubernetes.io/name: kafka
+         helm.sh/chart: kafka-23.0.1
+         app.kubernetes.io/instance: kafka-prod
+         app.kubernetes.io/managed-by: Helm
+         app.kubernetes.io/component: kafka
+       annotations:
+         checksum/jaas-secret: 996b0a5125c78a385e3221c4b3a45b7475dc9a75456066dbb23aff0beb75742e
+     spec:
+       
+       hostNetwork: false
+       hostIPC: false
+       affinity:
+         podAffinity:
+           
+         podAntiAffinity:
+           preferredDuringSchedulingIgnoredDuringExecution:
+             - podAffinityTerm:
+                 labelSelector:
+                   matchLabels:
+                     app.kubernetes.io/name: kafka
+                     app.kubernetes.io/instance: kafka-prod
+                     app.kubernetes.io/component: kafka
+                 topologyKey: kubernetes.io/hostname
+               weight: 1
+         nodeAffinity:
+           
+       securityContext:
+         fsGroup: 1001
+       serviceAccountName: kafka-prod
+       containers:
+         - name: kafka
+           image: docker.io/bitnami/kafka:3.5.2
+           imagePullPolicy: "IfNotPresent"
+           securityContext:
+             allowPrivilegeEscalation: false
+             runAsNonRoot: true
+             runAsUser: 1001
+           command:
+             - /scripts/setup.sh
+           env:
+             - name: BITNAMI_DEBUG
+               value: "false"
+             - name: MY_POD_IP
+               valueFrom:
+                 fieldRef:
+                   fieldPath: status.podIP
+             - name: MY_POD_NAME
+               valueFrom:
+                 fieldRef:
+                   fieldPath: metadata.name
+             - name: KAFKA_CFG_ZOOKEEPER_CONNECT
+               value: 
+             - name: KAFKA_INTER_BROKER_LISTENER_NAME
+               value: "INTERNAL"
+             - name: KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP
+               value: "INTERNAL:SASL_PLAINTEXT,CLIENT:SASL_PLAINTEXT,CONTROLLER:PLAINTEXT"
+             - name: KAFKA_CFG_SASL_ENABLED_MECHANISMS
+               value: "PLAIN,SCRAM-SHA-256,SCRAM-SHA-512"
+             - name: KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL
+               value: "PLAIN"
+             - name: KAFKA_CFG_LISTENERS
+               value: "INTERNAL://:9094,CLIENT://:9092,CONTROLLER://:9093"
+             - name: KAFKA_CFG_ADVERTISED_LISTENERS
+               value: "INTERNAL://$(MY_POD_NAME).kafka-prod-headless.prod.svc.cluster.local:9094,CLIENT://$(MY_POD_NAME).kafka-prod-headless.prod.svc.cluster.local:9092"
+             - name: ALLOW_PLAINTEXT_LISTENER
+               value: "yes"
+             - name: KAFKA_OPTS
+               value: "-Djava.security.auth.login.config=/opt/bitnami/kafka/config/kafka_jaas.conf"
+             - name: KAFKA_CLIENT_USERS
+               value: "user"
+             - name: KAFKA_CLIENT_PASSWORDS
+               valueFrom:
+                 secretKeyRef:
+                   name: kafka-prod-jaas
+                   key: client-passwords
+             - name: KAFKA_INTER_BROKER_USER
+               value: "admin"
+             - name: KAFKA_INTER_BROKER_PASSWORD
+               valueFrom:
+                 secretKeyRef:
+                   name: kafka-prod-jaas
+                   key: inter-broker-password
+             - name: KAFKA_ZOOKEEPER_PROTOCOL
+               value: PLAINTEXT
+             - name: KAFKA_VOLUME_DIR
+               value: "/bitnami/kafka"
+             - name: KAFKA_LOG_DIR
+               value: "/opt/bitnami/kafka/logs"
+             - name: KAFKA_CFG_DELETE_TOPIC_ENABLE
+               value: "false"
+             - name: KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE
+               value: "true"
+             - name: KAFKA_HEAP_OPTS
+               value: "-Xmx1024m -Xms1024m"
+             - name: KAFKA_CFG_LOG_FLUSH_INTERVAL_MESSAGES
+               value: "10000"
+             - name: KAFKA_CFG_LOG_FLUSH_INTERVAL_MS
+               value: "1000"
+             - name: KAFKA_CFG_LOG_RETENTION_BYTES
+               value: "1073741824"
+             - name: KAFKA_CFG_LOG_RETENTION_CHECK_INTERVAL_MS
+               value: "300000"
+             - name: KAFKA_CFG_LOG_RETENTION_HOURS
+               value: "168"
+             - name: KAFKA_CFG_MESSAGE_MAX_BYTES
+               value: "1000012"
+             - name: KAFKA_CFG_LOG_SEGMENT_BYTES
+               value: "1073741824"
+             - name: KAFKA_CFG_LOG_DIRS
+               value: "/bitnami/kafka/data"
+             - name: KAFKA_CFG_DEFAULT_REPLICATION_FACTOR
+               value: "1"
+             - name: KAFKA_CFG_OFFSETS_TOPIC_REPLICATION_FACTOR
+               value: "1"
+             - name: KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR
+               value: "1"
+             - name: KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR
+               value: "1"
+             - name: KAFKA_CFG_NUM_IO_THREADS
+               value: "8"
+             - name: KAFKA_CFG_NUM_NETWORK_THREADS
+               value: "3"
+             - name: KAFKA_CFG_NUM_PARTITIONS
+               value: "1"
+             - name: KAFKA_CFG_NUM_RECOVERY_THREADS_PER_DATA_DIR
+               value: "1"
+             - name: KAFKA_CFG_SOCKET_RECEIVE_BUFFER_BYTES
+               value: "102400"
+             - name: KAFKA_CFG_SOCKET_REQUEST_MAX_BYTES
+               value: "104857600"
+             - name: KAFKA_CFG_SOCKET_SEND_BUFFER_BYTES
+               value: "102400"
+             - name: KAFKA_CFG_ZOOKEEPER_CONNECTION_TIMEOUT_MS
+               value: "6000"
+             - name: KAFKA_CFG_AUTHORIZER_CLASS_NAME
+               value: ""
+             - name: KAFKA_CFG_ALLOW_EVERYONE_IF_NO_ACL_FOUND
+               value: "true"
+             - name: KAFKA_CFG_SUPER_USERS
+               value: "User:admin"
+             - name: KAFKA_ENABLE_KRAFT
+               value: "true"
+             - name: KAFKA_KRAFT_CLUSTER_ID
+               value: "kafka_cluster_id_test1"
+             - name: KAFKA_CFG_PROCESS_ROLES
+               value: "broker,controller"
+             - name: KAFKA_CFG_CONTROLLER_LISTENER_NAMES
+               value: "CONTROLLER"
+           ports:
+             - name: kafka-client
+               containerPort: 9092
+             - name: kafka-internal
+               containerPort: 9094
+             - name: kafka-ctlr
+               containerPort: 9093
+           livenessProbe:
+             failureThreshold: 3
+             initialDelaySeconds: 10
+             periodSeconds: 10
+             successThreshold: 1
+             timeoutSeconds: 5
+             tcpSocket:
+               port: kafka-client
+           readinessProbe:
+             failureThreshold: 6
+             initialDelaySeconds: 5
+             periodSeconds: 10
+             successThreshold: 1
+             timeoutSeconds: 5
+             tcpSocket:
+               port: kafka-client
+           resources:
+             limits: {}
+             requests: {}
+           volumeMounts:
+             - name: data
+               mountPath: /bitnami/kafka
+             - name: logs
+               mountPath: /opt/bitnami/kafka/logs
+             - name: scripts
+               mountPath: /scripts/setup.sh
+               subPath: setup.sh
+       volumes:
+         - name: scripts
+           configMap:
+             name: kafka-prod-scripts
+             defaultMode: 0755
+         - name: logs
+           emptyDir: {}
+   volumeClaimTemplates:
+     - metadata:
+         name: data
+       spec:
+         accessModes:
+           - "ReadWriteOnce"
+         resources:
+           requests:
+             storage: "8Gi"
prod, kafka-prod-headless, Service (v1) has been added:
- 
+ # Source: kafka/templates/svc-headless.yaml
+ apiVersion: v1
+ kind: Service
+ metadata:
+   name: kafka-prod-headless
+   namespace: "prod"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/component: kafka
+ spec:
+   type: ClusterIP
+   clusterIP: None
+   publishNotReadyAddresses: false
+   ports:
+     - name: tcp-client
+       port: 9092
+       protocol: TCP
+       targetPort: kafka-client
+     - name: tcp-internal
+       port: 9094
+       protocol: TCP
+       targetPort: kafka-internal
+     - name: tcp-controller
+       protocol: TCP
+       port: 9093
+       targetPort: kafka-ctlr
+   selector:
+     app.kubernetes.io/name: kafka
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/component: kafka
prod, kafka-prod-jaas, Secret (v1) has been added:
+ # Source: kafka/templates/jaas-secret.yaml
+ apiVersion: v1
+ kind: Secret
+ metadata:
+   labels:
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/managed-by: Helm
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+   name: kafka-prod-jaas
+   namespace: prod
+ data:
+   client-passwords: '++++++++ # (10 bytes)'
+   inter-broker-password: '++++++++ # (10 bytes)'
+   system-user-password: '++++++++ # (10 bytes)'
+ type: Opaque

prod, kafka-prod-scripts, ConfigMap (v1) has been added:
+ # Source: kafka/templates/scripts-configmap.yaml
+ apiVersion: v1
+ kind: ConfigMap
+ metadata:
+   name: kafka-prod-scripts
+   namespace: "prod"
+   labels:
+     app.kubernetes.io/name: kafka
+     helm.sh/chart: kafka-23.0.1
+     app.kubernetes.io/instance: kafka-prod
+     app.kubernetes.io/managed-by: Helm
+ data:
+   setup.sh: |-
+     #!/bin/bash
+ 
+     ID="${MY_POD_NAME#"kafka-prod-"}"
+     # If process.roles is not set at all, it is assumed to be in ZooKeeper mode.
+     # https://kafka.apache.org/documentation/#kraft_role
+ 
+     if [[ -f "/bitnami/kafka/data/meta.properties" ]]; then
+         if [[ $KAFKA_CFG_PROCESS_ROLES == "" ]]; then
+             export KAFKA_CFG_BROKER_ID="$(grep "broker.id" "/bitnami/kafka/data/meta.properties" | awk -F '=' '{print $2}')"
+         else
+             export KAFKA_CFG_NODE_ID="$(grep "node.id" "/bitnami/kafka/data/meta.properties" | awk -F '=' '{print $2}')"
+         fi
+     else
+         if [[ $KAFKA_CFG_PROCESS_ROLES == "" ]]; then
+             export KAFKA_CFG_BROKER_ID="$((ID + 0))"
+         else
+             export KAFKA_CFG_NODE_ID="$((ID + 0))"
+         fi
+     fi
+ 
+     if [[ $KAFKA_CFG_PROCESS_ROLES == *"controller"* && -z $KAFKA_CFG_CONTROLLER_QUORUM_VOTERS ]]; then
+         node_id=0
+         pod_id=0
+         while :
+         do
+             VOTERS="${VOTERS}$node_id@kafka-prod-$pod_id.kafka-prod-headless.prod.svc.cluster.local:9093"
+             node_id=$(( $node_id + 1 ))
+             pod_id=$(( $pod_id + 1 ))
+             if [[ $pod_id -ge 5 ]]; then
+                 break
+             else
+                 VOTERS="$VOTERS,"
+             fi
+         done
+         export KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=$VOTERS
+     fi
+ 
+     # Configure zookeeper client

+     exec /entrypoint.sh /run.sh

Release "kafka-dev" does not exist. Installing it now.
NAME: kafka-dev
LAST DEPLOYED: Sun Jun 23 16:11:07 2024
NAMESPACE: dev
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kafka
CHART VERSION: 23.0.1
APP VERSION: 3.5.0

** Please be patient while the chart is being deployed **

Kafka can be accessed by consumers via port 9092 on the following DNS name from within your cluster:

    kafka-dev.dev.svc.cluster.local

Each Kafka broker can be accessed by producers via port 9092 on the following DNS name(s) from within your cluster:

    kafka-dev-0.kafka-dev-headless.dev.svc.cluster.local:9092

To create a pod that you can use as a Kafka client run the following commands:

    kubectl run kafka-dev-client --restart='Never' --image docker.io/bitnami/kafka:latest --namespace dev --command -- sleep infinity
    kubectl exec --tty -i kafka-dev-client --namespace dev -- bash

    PRODUCER:
        kafka-console-producer.sh \
            --broker-list kafka-dev-0.kafka-dev-headless.dev.svc.cluster.local:9092 \
            --topic test

    CONSUMER:
        kafka-console-consumer.sh \
            --bootstrap-server kafka-dev.dev.svc.cluster.local:9092 \
            --topic test \
            --from-beginning
WARNING: Rolling tag detected (bitnami/kafka:latest), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/

kafka-dev	dev      	1       	2024-06-23 16:11:07.774980405 +0300 MSK	deployed	kafka-23.0.1	3.5.0      

Release "kafka-prod" does not exist. Installing it now.
NAME: kafka-prod
LAST DEPLOYED: Sun Jun 23 16:11:07 2024
NAMESPACE: prod
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kafka
CHART VERSION: 23.0.1
APP VERSION: 3.5.0

** Please be patient while the chart is being deployed **

Kafka can be accessed by consumers via port 9092 on the following DNS name from within your cluster:

    kafka-prod.prod.svc.cluster.local

Each Kafka broker can be accessed by producers via port 9092 on the following DNS name(s) from within your cluster:

    kafka-prod-0.kafka-prod-headless.prod.svc.cluster.local:9092
    kafka-prod-1.kafka-prod-headless.prod.svc.cluster.local:9092
    kafka-prod-2.kafka-prod-headless.prod.svc.cluster.local:9092
    kafka-prod-3.kafka-prod-headless.prod.svc.cluster.local:9092
    kafka-prod-4.kafka-prod-headless.prod.svc.cluster.local:9092

You need to configure your Kafka client to access using SASL authentication. To do so, you need to create the 'kafka_jaas.conf' and 'client.properties' configuration files with the content below:

    - kafka_jaas.conf:

KafkaClient {
org.apache.kafka.common.security.scram.ScramLoginModule required
username="user"
password="$(kubectl get secret kafka-prod-jaas --namespace prod -o jsonpath='{.data.client-passwords}' | base64 -d | cut -d , -f 1)";
};

    - client.properties:

security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-256

To create a pod that you can use as a Kafka client run the following commands:

    kubectl run kafka-prod-client --restart='Never' --image docker.io/bitnami/kafka:3.5.2 --namespace prod --command -- sleep infinity
    kubectl cp --namespace prod /path/to/client.properties kafka-prod-client:/tmp/client.properties
    kubectl cp --namespace prod /path/to/kafka_jaas.conf kafka-prod-client:/tmp/kafka_jaas.conf
    kubectl exec --tty -i kafka-prod-client --namespace prod -- bash
    export KAFKA_OPTS="-Djava.security.auth.login.config=/tmp/kafka_jaas.conf"

    PRODUCER:
        kafka-console-producer.sh \
            --producer.config /tmp/client.properties \
            --broker-list kafka-prod-0.kafka-prod-headless.prod.svc.cluster.local:9092,kafka-prod-1.kafka-prod-headless.prod.svc.cluster.local:9092,kafka-prod-2.kafka-prod-headless.prod.svc.cluster.local:9092,kafka-prod-3.kafka-prod-headless.prod.svc.cluster.local:9092,kafka-prod-4.kafka-prod-headless.prod.svc.cluster.local:9092 \
            --topic test

    CONSUMER:
        kafka-console-consumer.sh \
            --consumer.config /tmp/client.properties \
            --bootstrap-server kafka-prod.prod.svc.cluster.local:9092 \
            --topic test \
            --from-beginning
WARNING: Rolling tag detected (bitnami/kafka:3.5.2), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/

kafka-prod	prod     	1       	2024-06-23 16:11:07.963228978 +0300 MSK	deployed	kafka-23.0.1	3.5.0      

---------dev-----------
NAME          READY   STATUS    RESTARTS   AGE
kafka-dev-0   0/1     Running   0          16s
---------prod-----------
NAME              READY   STATUS              RESTARTS          AGE
kafka-prod-0      0/1     ContainerCreating   0                 10s
kafka-prod-1      0/1     ContainerCreating   0                 10s
kafka-prod-2      0/1     Running             0                 10s
kafka-prod-3      0/1     ContainerCreating   0                 10s
kafka-prod-4      0/1     ContainerCreating   0                 4s
kafka-release-0   0/1     CrashLoopBackOff    742 (4m32s ago)   39h
kafka-release-1   0/1     Running             743 (32s ago)     39h
kafka-release-2   0/1     CrashLoopBackOff    741 (3m32s ago)   39h
kafka-release-3   0/1     CrashLoopBackOff    742 (4m45s ago)   39h
kafka-release-4   0/1     Running             743 (32s ago)     39h
```
## PR checklist:
 - [ ] Выставлен label с темой домашнего задания