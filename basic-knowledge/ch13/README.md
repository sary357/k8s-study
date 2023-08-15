## configmap creation
- create configmap with command
```
$ kubectl create configmap my-config --from-file=13-1_my-config.txt --from-literal=extra-param=extra-value --from-literal=another-param=another-value

```

- verify it
```
$ kubectl get configmap my-config -o yaml
apiVersion: v1
data:
  13-1_my-config.txt: |+
    parameter1 = value1
    parameter2 = value2

  another-param: another-value
  extra-param: extra-value
kind: ConfigMap
metadata:
  creationTimestamp: "2023-08-14T00:54:40Z"
  name: my-config
  namespace: default
  resourceVersion: "582568471"
  uid: ce8791aa-84f6-427b-b20b-c0420b46106e

```

## secrets creation
- get TLS key and certificate
```
$ curl -o kuard.crt https://storage.googleapis.com/kuar-demo/kuard.crt
$ curl -o kuard.key https://storage.googleapis.com/kuar-demo/kuard.key

```

- create secrets
```
$ kubectl create secret generic kuard-tls --from-file=kuard.crt --from-file=kuard.key
```

- verify it
```
$ kubectl describe secret kuard-tls
Name:         kuard-tls
Namespace:    fuming-poc
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
kuard.crt:  1050 bytes
kuard.key:  1679 bytes

```


## configmap and secret management
- get the list of configmap and secrets
```
$ kubectl get secrets
NAME        TYPE     DATA   AGE
kuard-tls   Opaque   2      7m18s

$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      103d
my-config          3      42m

```

- get details of configmap/secrets
```
$ kubectl describe configmap my-config
Name:         my-config
Namespace:    fuming-poc
Labels:       <none>
Annotations:  <none>

Data
====
13-1_my-config.txt:
----
parameter1 = value1
parameter2 = value2


another-param:
----
another-value
extra-param:
----
extra-value

BinaryData
====

Events:  <none>

```

- get raw data with `kubectl get configmap` or `kubectl get secrets`
```
$ kubectl get  secrets kuard-tls -o yaml
apiVersion: v1
data:
  kuard.crt: LS0t....
  kuard.key: LS0t....
kind: Secret
metadata:
  creationTimestamp: "2023-08-14T01:29:10Z"
  name: kuard-tls
  namespace: fuming-poc
  resourceVersion: "582587691"
  uid: d059e40d-32b5-4d4c-a7f7-e6a7946e4233
type: Opaque

```

- update configmap or secrets
```
$ kubectl create secret generic kuard-tls --from-file=kuard.crt --from-file=kuard.key  --dry-run=client  -o yaml | kubectl replace -f -
```
