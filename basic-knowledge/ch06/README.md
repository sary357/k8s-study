- Commands used in this chapter

1. create a deployment called `alpaca-prod`. P.S all labels will be only saved in `deployment`. The rest objects will not keep these labels. In addition, `kubectl run` already does not support `--replica` as well.
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

4. Let's check all labels
```
$ kubectl get deployments --show-labels
NAME                READY   UP-TO-DATE   AVAILABLE   AGE     LABELS
alpaca-prod         2/2     2            2           7m1s    app=alpaca,env=prod,ver=1
alpaca-test         1/1     1            1           3m10s   app=alpaca,env=test,evr=2
bandicoot-prod      2/2     2            2           115s    app=bandicoot,env=prod,ver=2
bandicoot-staging   1/1     1            1           48s     app=bandicoot,env=staging,ver=2

```

5. add 1 more label

```
$ kubectl label deployments alpaca-test "canary=true"
```

6. list

```
$ kubectl get deployments -L canary
NAME                READY   UP-TO-DATE   AVAILABLE   AGE   CANARY
alpaca-prod         2/2     2            2           27m   
alpaca-test         1/1     1            1           23m   true
bandicoot-prod      2/2     2            2           21m   
bandicoot-staging   1/1     1            1           20m   

```

7. remove label

```
$ kubectl label deployments alpaca-test "canary-"
```

8. labels selector: let's select all deployments if "ver=2"
```
$ kubectl get deployment -l ver=2 --show-labels
NAME                READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
alpaca-test         1/1     1            1           24m   app=alpaca,env=test,ver=2
bandicoot-prod      2/2     2            2           23m   app=bandicoot,env=prod,ver=2
bandicoot-staging   1/1     1            1           22m   app=bandicoot,env=staging,ver=2

$ kubectl get deployment --selector "ver=2" --show-labels
NAME                READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
alpaca-test         1/1     1            1           25m   app=alpaca,env=test,ver=2
bandicoot-prod      2/2     2            2           24m   app=bandicoot,env=prod,ver=2
bandicoot-staging   1/1     1            1           22m   app=bandicoot,env=staging,ver=2
```

9. multiple selector: use comma `,` to select deployments that match "ALL" rules. It looks like "AND" operation.
```
$ kubectl get deployment -l "ver=2,env=staging" --show-labels
NAME                READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
bandicoot-staging   1/1     1            1           24m   app=bandicoot,env=staging,ver=2

$ kubectl get deployment --selector "ver=2,env=staging" --show-labels
NAME                READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
bandicoot-staging   1/1     1            1           23m   app=bandicoot,env=staging,ver=2

```

10. we can use `in` as long as label match one of rule. It's "OR" operation.
```
$ kubectl get deployment -l "app in (alpaca, bandicoot)" --show-labels
NAME                READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
alpaca-prod         2/2     2            2           32m   app=alpaca,env=prod,ver=1
alpaca-test         1/1     1            1           28m   app=alpaca,env=test,ver=2
bandicoot-prod      2/2     2            2           27m   app=bandicoot,env=prod,ver=2
bandicoot-staging   1/1     1            1           26m   app=bandicoot,env=staging,ver=2
```

11. delete all deployments

```
$ kubectl delete deployments --all
```
