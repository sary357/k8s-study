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

## 16-8_storageclass.yaml
- `16-8_storageclass.yaml` in this folder is only for GCP. However, `16-8 storageclass.yaml` in book is for Azure. 

## 16-11_mongo-service.yaml
- after applying 16-11_mongo-service.yaml, we will have DNS name like mongo-X.mongo.NAMESPACE_NAME.svc.cluster.local. (X is like 0, 1, 2,... ,etc and NAMESPACE_NAME is namespace name.)
- we can use the following commands to understand their IP in k8s cluster
```
$ kubectl run -it --rm --image busybox busybox ping mongo-0.mongo
If you don't see a command prompt, try pressing enter.
64 bytes from 10.212.3.9: seq=2 ttl=62 time=0.332 ms
64 bytes from 10.212.3.9: seq=3 ttl=62 time=0.378 ms
64 bytes from 10.212.3.9: seq=4 ttl=62 time=0.376 ms
^C                                                     <------------------------------------- Ctl + C
--- mongo-0.mongo ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 0.274/0.556/1.423 ms
Session ended, resume using 'kubectl attach busybox -c busybox -i -t' command when the pod is running
pod "busybox" deleted

$ kubectl run -it --rm --image busybox busybox ping mongo-1.mongo
If you don't see a command prompt, try pressing enter.
64 bytes from 10.212.2.9: seq=1 ttl=62 time=0.638 ms
64 bytes from 10.212.2.9: seq=2 ttl=62 time=0.721 ms
^C                                                     <------------------------------------- Ctl + C
--- mongo-1.mongo ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.638/1.026/1.721 ms
Session ended, resume using 'kubectl attach busybox -c busybox -i -t' command when the pod is running
pod "busybox" deleted

$ kubectl run -it --rm --image busybox busybox ping mongo-2.mongo
If you don't see a command prompt, try pressing enter.
64 bytes from 10.212.3.12: seq=2 ttl=62 time=0.384 ms
64 bytes from 10.212.3.12: seq=3 ttl=62 time=0.386 ms
64 bytes from 10.212.3.12: seq=4 ttl=62 time=0.394 ms
64 bytes from 10.212.3.12: seq=5 ttl=62 time=0.350 ms
^C                                                     <------------------------------------- Ctl + C
--- mongo-2.mongo ping statistics ---
6 packets transmitted, 6 packets received, 0% packet loss
round-trip min/avg/max = 0.350/0.554/1.461 ms
Session ended, resume using 'kubectl attach busybox -c busybox -i -t' command when the pod is running
pod "busybox" deleted

```

- initialize mongo manually
```
$ kubectl exec -it mongo-0 mongo
> rs.initiate({ _id:"rs0", members:[{_id:0, host:"mongo-0.mongo:27017"}]});
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1693359701, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1693359701, 1)
}

rs0:PRIMARY> rs.add("mongo-1.mongo:27017")
rs0:PRIMARY> rs.add("mongo-2.mongo:27017")
```

## 16-13_mongo.yaml
- after creating 16-12_configmap.yaml, 16-11_mongo-service.yaml, and 16-13_mongo.yaml, we can start up a mongodb cluster with the following commands
```
$ kubectl apply -f 16-12_configmap.yaml
$ kubectl apply -f 16-11_mongo-service.yaml
$ kubectl apply -f 16-13_mongo.yaml
```
- we can check the status

```
$ kubectl get pods
NAME                                         READY   STATUS    RESTARTS      AGE
mongo-0                                      2/2     Running   0          84s
mongo-1                                      2/2     Running   0          83s
mongo-2                                      2/2     Running   0          82s

```

- Attention!! in `16-12_configmap.yaml`, This script currently sleeps forever after initializing the cluster. Every container in a Pod has to have the same RestartPolicy. Since we do not want our main Mongo container to be restarted, we need to have our initialization container run forever too, or else Kubernetes might think our Mongo Pod is unhealthy. This part is different from the 3rd edition.
