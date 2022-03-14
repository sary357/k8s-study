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

# apply 8-1_simple-ingress.yaml

```
$ kubectl apply -f 8-1_simple-ingress.yaml
```

# verify

```
$ kubectl get ingress
NAME             CLASS    HOSTS   ADDRESS          PORTS   AGE
simple-ingress   <none>   *       35.247.135.128   80      115s
$ kubectl describe ingress simple-ingress
Name:             simple-ingress
Labels:           <none>
Namespace:        default
Address:          35.247.135.128
Default backend:  alpaca:8080 (10.212.4.23:8080,10.212.4.24:8080,10.212.4.25:8080)
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           *     alpaca:8080 (10.212.4.23:8080,10.212.4.24:8080,10.212.4.25:8080)
Annotations:  ingress.kubernetes.io/backends: {"k8s1-16742a51-default-alpaca-8080-70b5ddce":"HEALTHY"}
              ingress.kubernetes.io/forwarding-rule: k8s2-fr-x4xdyn98-default-simple-ingress-2441as3f
              ingress.kubernetes.io/target-proxy: k8s2-tp-x4xdyn98-default-simple-ingress-2441as3f
              ingress.kubernetes.io/url-map: k8s2-um-x4xdyn98-default-simple-ingress-2441as3f
Events:
  Type    Reason     Age                   From                     Message
  ----    ------     ----                  ----                     -------
  Normal  Sync       103s                  loadbalancer-controller  UrlMap "k8s2-um-x4xdyn98-default-simple-ingress-2441as3f" created
  Normal  Sync       99s                   loadbalancer-controller  TargetProxy "k8s2-tp-x4xdyn98-default-simple-ingress-2441as3f" created
  Normal  Sync       89s                   loadbalancer-controller  ForwardingRule "k8s2-fr-x4xdyn98-default-simple-ingress-2441as3f" created
  Normal  IPChanged  12s (x6 over 88s)     loadbalancer-controller  IP is now 34.102.155.51
  Normal  Sync       11s (x16 over 2m26s)  loadbalancer-controller  Scheduled for sync

```

# apply 8-2_host-ingress.yaml

```
$ kubectl apply -f 8-2_host-ingress.yaml
```

# Verify

```
$ kubectl get ingress
NAME            CLASS    HOSTS                ADDRESS          PORTS   AGE
basic-ingress   <none>   *                    35.247.135.128   80      16d
host-ingress    <none>   alpaca.example.com   35.247.135.128   80      17s

$ kubectl describe ingress host-ingress
Name:             host-ingress
Labels:           <none>
Namespace:        default
Address:          35.247.135.128
Default backend:  default-http-backend:80 (10.212.1.10:8080)
Rules:
  Host                Path  Backends
  ----                ----  --------
  alpaca.example.com  
                      /   alpaca:8080 (10.212.1.22:8080,10.212.1.3:8080,10.212.1.5:8080)
Annotations:          <none>
Events:
  Type    Reason  Age                From                     Message
  ----    ------  ----               ----                     -------
  Normal  Sync    31s (x3 over 37s)  loadbalancer-controller  Scheduled for sync

```

# check http://alpaca.example.com on browser (Chrome or safari)

# apply  8-3_path-ingree.yaml

```
$ kubectl apply -f  8-3_path-ingree.yaml
```

# check 1) http://bandicoot.example.com/ and 2) http://bandicoot.example.com/a/. Then, compare the difference.

# remove them all.

```
$ kubectl get ingress

$ kubectl delete ingress host-ingress path-ingress simple-ingress

$ kubectl get services
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
alpaca       ClusterIP   10.216.15.21   <none>        8080/TCP       3d
bandicoot    ClusterIP   10.216.15.71   <none>        8080/TCP       3d
be-default   ClusterIP   10.216.11.67   <none>        8080/TCP       3d
kubernetes   ClusterIP   10.216.0.1     <none>        443/TCP        254d
web          NodePort    10.216.6.194   <none>        80:32343/TCP   16d

$ kubectl delete services  alpaca bandicoot be-default
service "alpaca" deleted
service "bandicoot" deleted
service "be-default" deleted

$ kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
alpaca       3/3     3            3           3d
bandicoot    3/3     3            3           3d
be-default   3/3     3            3           3d
web          1/1     1            1           16d

$ kubectl delete deployments alpaca bandicoot be-default 
deployment.apps "alpaca" deleted
deployment.apps "bandicoot" deleted
deployment.apps "be-default" deleted

```

---- 
