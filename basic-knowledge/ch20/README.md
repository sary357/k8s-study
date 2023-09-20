## install gatekeeper with helm
- add helm repo
```
$ helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
``` 

- install gatekeeper (the following command will install gatekeeper in the namespace `gatekeeper-system`.
```
$ helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace
``` 

- check whether gatekeeper is working fine
```
$ kubectl get  all -n gatekeeper-system
NAME                                                 READY   STATUS    RESTARTS      AGE
pod/gatekeeper-audit-85b4f49c6f-srtxh                1/1     Running   1 (15m ago)   16m
pod/gatekeeper-controller-manager-6cb75c588f-dmgpf   1/1     Running   0             16m
pod/gatekeeper-controller-manager-6cb75c588f-jk2dq   1/1     Running   0             16m
pod/gatekeeper-controller-manager-6cb75c588f-ptjvq   1/1     Running   0             16m

NAME                                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/gatekeeper-webhook-service   ClusterIP   10.216.2.86   <none>        443/TCP   16m

NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/gatekeeper-audit                1/1     1            1           16m
deployment.apps/gatekeeper-controller-manager   3/3     3            3           16m

NAME                                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/gatekeeper-audit-85b4f49c6f                1         1         1       16m
replicaset.apps/gatekeeper-controller-manager-6cb75c588f   3         3         3       16m

```

- Let's see how to set up webhook
```
$ kubectl get validatingwebhookconfiguration gatekeeper-validating-webhook-configuration    -o yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  annotations:
    meta.helm.sh/release-name: gatekeeper
    meta.helm.sh/release-namespace: gatekeeper-system
  creationTimestamp: "2023-09-12T01:18:53Z"
  generation: 2
  labels:
    app: gatekeeper
    app.kubernetes.io/managed-by: Helm
    chart: gatekeeper
    gatekeeper.sh/system: "yes"
    heritage: Helm
    release: gatekeeper
  name: gatekeeper-validating-webhook-configuration
  resourceVersion: "606102655"
  uid: 3ed9148e-594e-438e-bdfd-bacb4d52a6f8
webhooks:
- admissionReviewVersions:
  - v1
  - v1beta1
  clientConfig:
    caBundle: L****Cg==
    service:
      name: gatekeeper-webhook-service
      namespace: gatekeeper-system
      path: /v1/admit
      port: 443
  failurePolicy: Ignore
  matchPolicy: Exact
  name: validation.gatekeeper.sh
  namespaceSelector:
    matchExpressions:
    - key: admission.gatekeeper.sh/ignore
      operator: DoesNotExist
    - key: kubernetes.io/metadata.name
      operator: NotIn
      values:
      - gatekeeper-system
  objectSelector: {}
  rules:
  - apiGroups:
    - '*'
    apiVersions:
    - '*'
    operations:
    - CREATE
    - UPDATE
    resources:
    - '*'
    - pods/ephemeralcontainers
    - pods/exec
    - pods/log
    - pods/eviction
    - pods/portforward
    - pods/proxy
    - pods/attach
    - pods/binding
    - deployments/scale
    - replicasets/scale
    - statefulsets/scale
    - replicationcontrollers/scale
    - services/proxy
    - nodes/proxy
    - services/status
    scope: '*'
  sideEffects: None
  timeoutSeconds: 3
- admissionReviewVersions:
  - v1
  - v1beta1
  clientConfig:
    caBundle: LS*****Cg==
    service:
      name: gatekeeper-webhook-service
      namespace: gatekeeper-system
      path: /v1/admitlabel
      port: 443
  failurePolicy: Fail
  matchPolicy: Exact
  name: check-ignore-label.gatekeeper.sh
  namespaceSelector:
    matchExpressions:
    - key: kubernetes.io/metadata.name
      operator: NotIn
      values:
      - gatekeeper-system
  objectSelector: {}
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - '*'
    operations:
    - CREATE
    - UPDATE
    resources:
    - namespaces
    scope: '*'
  sideEffects: None
  timeoutSeconds: 3


```

## Configure policies
- define `constraint template`. (https://github.com/open-policy-agent/gatekeeper-library/tree/master/library/general/allowedrepos/samples/repo-must-be-openpolicyagent = https://oreil.ly/ikfZk). However, we should refer to https://github.com/open-policy-agent/gatekeeper-library/blob/master/library/general/allowedrepos/template.yaml (I already downloaded and saved it as 20-1_allowedrepos-constraint-template.yaml)
