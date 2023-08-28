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
- btw, I found PV and PVC can only be used once. If I mount PV and PVC, then I remove PVC. I found I can not mount PV with other PVC. (假如我把 PV 和 PVC 都連接起來, 然後刪掉 PVC, 就發現 PV 是 released 且無法再被新的 PVC 給 mount 起來, 除非重新建立 PV)
