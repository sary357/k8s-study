- Commands used in this chapter

1. create a deployment called `alpaca-prod`. P.S all labels will be only saved in `deployment`.  The rest objects will not keep these labels

```
$ kubectl create deployment alpaca-prod --image=gcr.io/kuar-demo/kuard-amd64:blue --replicas=3 --port=8080
$ kubectl label deployments alpaca-prod "ver=1"
$ kubectl label deployments alpaca-prod "app=alpaca" --overwrite
$ kubectl label deployments alpaca-prod "env=prod"
$ kubectl expose deployment alpaca-prod
```

2. create a deployment: `bandicoot-prod`

```
$ kubectl create deployment bandicoot-prod --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=2 --port=8080
$ kubectl label deployments bandicoot-prod "ver=2"
$ kubectl label deployments bandicoot-prod "app=bandicoot" --overwrite
$ kubectl label deployments bandicoot-prod "env=prod"
$ kubectl expose deployment bandicoot-prod

```

3. check services

```
$ kubectl get service -o wide --show-labels
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE     SELECTOR             LABELS
alpaca-prod      ClusterIP   10.35.251.106   <none>        8080/TCP   7m41s   app=alpaca-prod      app=alpaca,env=prod,ver=1
bandicoot-prod   ClusterIP   10.35.240.64    <none>        8080/TCP   7m13s   app=bandicoot-prod   app=bandicoot,env=prod,ver=2
kubernetes       ClusterIP   10.35.240.1     <none>        443/TCP    6d16h   <none>               component=apiserver,provider=kubernetes

```

4. port forward to localhost

```
$ ALPACA_POD_0=` kubectl get pods -l app=alpaca-prod -o jsonpath='{.items[0].metadata.name}'`
$ kubectl port-forward $ALPACA_POD_0 49958:8080
```
5. list the deployments which has a label `canary`

```
$ kubectl label deployment  alpaca-prod "canary=True"
$ kubectl get deployments -L canary
```

6. remove label

```
$ kubectl label deployments alpaca-prod "canary-"
```

7. delete all deployments

```
$ kubectl delete deployments --all
```
