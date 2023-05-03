- Commands used in this chapter

1. create a deployment called `alpaca-prod`. P.S all labels will be only saved in `deployment`.  The rest objects will not keep these labels

```
$ kubectl create deployment alpaca-prod --image=gcr.io/kuar-demo/kuard-amd64:blue --replicas=2 
$ kubectl label deployments alpaca-prod "ver=1"
$ kubectl label deployments alpaca-prod "app=alpaca" --overwrite
$ kubectl label deployments alpaca-prod "env=prod"
```
P.S: we can use `alpaca-prod.yaml` ather than using commands above.

2. create a deployment called `alpaca-test`

```
$ kubectl create deployment alpaca-test --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=1
$ kubectl label deployments alpaca-test "ver=2"
$ kubectl label deployments alpaca-test "app=alpaca" --overwrite
$ kubectl label deployments alpaca-test "env=test"
```
P.S: we can use `alpaca-test.yaml` ather than using commands above.

3. create 2 deployments: `bandicoot-prod` and `bandicoot-staging`

```
$ kubectl create deployment bandicoot-prod --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=2
$ kubectl label deployments bandicoot-prod "ver=2"
$ kubectl label deployments bandicoot-prod "app=bandicoot" --overwrite
$ kubectl label deployments bandicoot-prod "env=prod"

$ kubectl create deployment bandicoot-staging --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=1
$ kubectl label deployments bandicoot-staging "ver=2"
$ kubectl label deployments bandicoot-staging "app=bandicoot" --overwrite
$ kubectl label deployments bandicoot-staging "env=staging"
```
P.S: we can use `bandicoot-staging.yaml` and `bandicoot-prod.yaml` rather than using commands above.

4. add 1 more label

```
$ kubectl label deployments alpaca-test "canary=true"
```

5. list

```
$ kubectl get deployments -L canary
```

6. remove label

```
$ kubectl label deployments alpaca-test "canary-"
```

7. delete all deployments

```
$ kubectl delete deployments --all
```
