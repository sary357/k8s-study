## Notes
- `10-1_kuard-deplyment-yam.yaml`: the output after executing `kubectl get deployments kuard -o yaml > 10-1_kuard-deplyment-yam.yaml`
```
$ kubectl get deployments kuard -o yaml > 10-1_kuard-deplyment-yam.yaml
```

- if you need to know the status of deployment, you can use `kubectl get deployments xxxx -o jsonpath --template {.status.conditions}` . if `type` = `Progressing` and `status` = `False`, that menas we fails to update our deployments.
```
 $ kubectl get deployments kuard -o jsonpath --template {.status.conditions}
[{"lastTransitionTime":"2023-08-08T01:08:48Z","lastUpdateTime":"2023-08-08T01:08:48Z","message":"Deployment has minimum availability.","reason":"MinimumReplicasAvailable","status":"True","type":"Available"},{"lastTransitionTime":"2023-08-08T00:52:49Z","lastUpdateTime":"2023-08-08T01:48:58Z","message":"ReplicaSet \"kuard-cbcbcb97\" has successfully progressed.","reason":"NewReplicaSetAvailable","status":"True","type":"Progressing"}]
```

