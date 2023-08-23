## 16-2_external-ip-service.yaml
- it does not work.
```
$ kubectl apply -f 16-2_external-ip-service.yaml 
The Service "external-ip-database" is invalid: spec.ports: Required value
```

## 16-4_nfs-volume.yaml
- Assume our NFS server is `10.186.0.53` and path on NFS server is `/exports`.
- On GKE, we need to specify `storageClass`.

## 16-5_nfs-volume-claim.yaml
- On GKE, it seems not to support `selector`. I have to specify `volumeName`.
- Again, we need to specify `storageClass`.
