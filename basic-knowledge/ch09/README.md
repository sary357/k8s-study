## Todo:
1. HPA (Horizontal Pod Autoscaling)
1.1 install 

1.1.1 metrics server

```
# component installation
$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.1/components.yaml
serviceaccount/metrics-server configured
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrole.rbac.authorization.k8s.io/system:metrics-server configured
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader configured
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator configured
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server configured
service/metrics-server configured
deployment.apps/metrics-server created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io configured

# HA
$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability.yaml
serviceaccount/metrics-server configured
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader unchanged
clusterrole.rbac.authorization.k8s.io/system:metrics-server configured
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader configured
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator configured
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server configured
service/metrics-server configured
deployment.apps/metrics-server configured
Warning: policy/v1beta1 PodDisruptionBudget is deprecated in v1.21+, unavailable in v1.25+; use policy/v1 PodDisruptionBudget
poddisruptionbudget.policy/metrics-server created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io configured


```

1.1.2 test metrics server

```
$ kubectl get pod -n kube-system # You're supposed to get the result like the following
NAME                                                             READY   STATUS    RESTARTS   AGE
...
...
metrics-server-5bffb474fc-tg5cs                                  1/1     Running   0          31s
metrics-server-5bffb474fc-xktrl                                  0/1     Running   0          15s
metrics-server-v0.5.2-8454fbddf4-bpgdn                           2/2     Running   0          4d7h
...


$ kubectl top nodes
NAME                                                  CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
gke-gogox-analytics--gogox-analytics--4cd78dab-uu9z   185m         9%     650Mi           11%       
gke-gogox-analytics--gogox-analytics--d7e97aaa-2tun   81m          4%     688Mi           12%       
gke-gogox-analytics--gogox-analytics--d7e97aaa-lcby   244m         12%    678Mi           12%       

$ kubectl top pods
NAME                              CPU(cores)   MEMORY(bytes)   
alpaca-prod-57489cf684-2ffv5      1m           2Mi             
alpaca-prod-57489cf684-gpspk      1m           2Mi             
alpaca-prod-57489cf684-vbw7m      1m           2Mi             
bandicoot-prod-7d56b46cf4-ffcgg   1m           1Mi             
bandicoot-prod-7d56b46cf4-fk55p   0m           1Mi             
kuard-nr5st                       0m           1Mi             
kuard-pnmcj                       0m           1Mi             

```

1.2 test HPA

```
$ kubectl apply -f 9-2_hpa.yaml
```
