# install contour

```
$ kubectl apply -f https://j.hept.io/contour-deployment-rbac
namespace/projectcontour created
serviceaccount/contour created
serviceaccount/envoy created
configmap/contour created
customresourcedefinition.apiextensions.k8s.io/contourconfigurations.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/contourdeployments.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/extensionservices.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/httpproxies.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/tlscertificatedelegations.projectcontour.io created
serviceaccount/contour-certgen created
rolebinding.rbac.authorization.k8s.io/contour created
role.rbac.authorization.k8s.io/contour-certgen created
job.batch/contour-certgen-v1.20.1 created
clusterrolebinding.rbac.authorization.k8s.io/contour created
clusterrole.rbac.authorization.k8s.io/contour created
service/contour created
service/envoy created
deployment.apps/contour created
daemonset.apps/envoy created

```

# get external service address of contour

```
$ kubectl get -n projectcontour service -o wide
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE     SELECTOR
contour   ClusterIP      10.216.5.71    <none>           8001/TCP                     4m30s   app=contour
envoy     LoadBalancer   10.216.10.87   35.247.135.128   80:32640/TCP,443:30610/TCP   4m29s   app=envoy

```

# add domain name to /etc/hosts

```
$ sudo echo "35.247.135.128 alpaca.example.com" > /etc/hosts
$ sudo echo "35.247.135.128 bandicoot.example.com" > /etc/hosts
```

# create some deployments

```
# 1. be-default
$ kubectl create deployment be-default --image=gcr.io/kuar-demo/kuard-amd64:blue --replicas=3 --port=8080
deployment.apps/be-default created
$ kubectl expose deployment be-default
service/be-default exposed

# 2. alpaca
$ kubectl create deployment alpaca --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=3 --port=8080
deployment.apps/alpaca created
$ kubectl expose deployment alpaca
service/alpaca exposed

# 3. bandicoot
$ kubectl create deployment bandicoot --image=gcr.io/kuar-demo/kuard-amd64:purple --replicas=3 --port=8080
deployment.apps/bandicoot created
$ kubectl expose deployment bandicoot
service/bandicoot exposed

# 4. check
$ kubectl get service -o wide
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE     SELECTOR
alpaca       ClusterIP   10.216.15.21   <none>        8080/TCP       46s     app=alpaca
bandicoot    ClusterIP   10.216.15.71   <none>        8080/TCP       15s     app=bandicoot
be-default   ClusterIP   10.216.11.67   <none>        8080/TCP       2m20s   app=be-default
kubernetes   ClusterIP   10.216.0.1     <none>        443/TCP        251d    <none>

```
