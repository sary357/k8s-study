## 19-2_amicontained-pod.yaml&19-3_amicontained-pod-securitycontact.yaml
- Because the ceritificate is not valid, you may encounter the following issue after applying `19-2_amicontained-pod.yaml` and `19-3_amicontained-pod-securitycontact.yaml`.
```
$ kubectl apply -f 19-3_amicontained-pod-securitycontext.yaml 
pod/amicontained created

$ kubectl describe pods amicontained
Name:         amicontained
Namespace:    fuming-poc
Priority:     0
Node:         gke-non-prod-cluster-pre-ubuntu-0774446c-gskf/10.186.0.50
....
....
....

Events:
  Type     Reason     Age               From               Message
  ----     ------     ----              ----               -------
  Normal   Scheduled  46s               default-scheduler  Successfully assigned fuming-poc/amicontained to gke-non-prod-cluster-pre-ubuntu-0774446c-gskf
  Warning  Failed     15s               kubelet            Failed to pull image "r.j3ss.co/amicontained:v0.4.9": rpc error: code = Unknown desc = failed to pull and unpack image "r.j3ss.co/amicontained:v0.4.9": failed to resolve reference "r.j3ss.co/amicontained:v0.4.9": failed to do request: Head "https://r.j3ss.co/v2/amicontained/manifests/v0.4.9": dial tcp 34.72.39.221:443: i/o timeout
  Warning  Failed     15s               kubelet            Error: ErrImagePull
  Normal   BackOff    15s               kubelet            Back-off pulling image "r.j3ss.co/amicontained:v0.4.9"
  Warning  Failed     15s               kubelet            Error: ImagePullBackOff
  Normal   Pulling    1s (x2 over 45s)  kubelet            Pulling image "r.j3ss.co/amicontained:v0.4.9"

```
- So, the best way to do is to build from source with `Go`. Please refer to https://github.com/genuinetools/amicontained (=https://oreil.ly/6ubkU)
- Security Profile Operator: https://github.com/kubernetes-sigs/security-profiles-operator (=https://oreil.ly/grPCN)

## Pod Security
- PSP: Pod security policy
- Pod Security Standards: https://kubernetes.io/docs/concepts/security/pod-security-standards/ (=https://oreil.ly/xPK2p)
- If you want to test security, you can use `--dry-run` like the following.
```
$ kubectl label --dry-run=server --overwrite ns --all pod-security.kuberetes.io/enforce=baseline
namespace/airflow labeled
namespace/apps labeled
namespace/cert-manager labeled
namespace/debezium labeled
namespace/default labeled
namespace/fuming-poc labeled
namespace/genesis-wall labeled
namespace/kube-node-lease labeled
namespace/kube-public labeled
namespace/kube-system labeled
namespace/monitoring labeled
namespace/projectcontour labeled

$ kubectl label --dry-run=server --overwrite ns --all pod-security.kuberetes.io/audit=restricted
namespace/airflow labeled
namespace/apps labeled
namespace/cert-manager labeled
namespace/debezium labeled
namespace/default labeled
namespace/fuming-poc labeled
namespace/genesis-wall labeled
namespace/kube-node-lease labeled
namespace/kube-public labeled
namespace/kube-system labeled
namespace/monitoring labeled
namespace/projectcontour labeled

$ kubectl label --dry-run=server --overwrite ns --all pod-security.kuberetes.io/warn=restricted
namespace/airflow labeled
namespace/apps labeled
namespace/cert-manager labeled
namespace/debezium labeled
namespace/default labeled
namespace/fuming-poc labeled
namespace/genesis-wall labeled
namespace/kube-node-lease labeled
namespace/kube-public labeled
namespace/kube-system labeled
namespace/monitoring labeled
namespace/projectcontour labeled

```
