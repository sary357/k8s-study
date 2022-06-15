- Test
```
$ helm install mydemo mychart/ --debug --dry-run
install.go:178: [debug] Original chart version: ""
install.go:195: [debug] CHART PATH: /Users/sary357/Desktop/gogox/study/k8s-study/helm-study/library_charts/mychart

NAME: mydemo
LAST DEPLOYED: Tue Jun 14 09:31:11 2022
NAMESPACE: default
STATUS: pending-install
REVISION: 1
TEST SUITE: None
USER-SUPPLIED VALUES:
{}

COMPUTED VALUES:
affinity: {}
autoscaling:
  enabled: false
  maxReplicas: 100
  minReplicas: 1
  targetCPUUtilizationPercentage: 80
fullnameOverride: ""
image:
  pullPolicy: IfNotPresent
  repository: nginx
  tag: ""
imagePullSecrets: []
ingress:
  annotations: {}
  className: ""
  enabled: false
  hosts:
  - host: chart-example.local
    paths:
    - path: /
      pathType: ImplementationSpecific
  tls: []
mylibchart:
  global: {}
nameOverride: ""
nodeSelector: {}
podAnnotations: {}
podSecurityContext: {}
replicaCount: 1
resources: {}
securityContext: {}
service:
  port: 80
  type: ClusterIP
serviceAccount:
  annotations: {}
  create: true
  name: ""
tolerations: []

HOOKS:
MANIFEST:
---
# Source: mychart/templates/configmap.yaml
apiVersion: v1
data:
  myvalue: Hello World
kind: ConfigMap
metadata:
  name: mychart-mydemo

```

- Install
```
$ helm install mydemo mychart/
NAME: mydemo
LAST DEPLOYED: Tue Jun 14 09:32:59 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

$ helm ls
NAME                	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART           	APP VERSION
mydemo              	default  	1       	2022-06-14 09:32:59.392486 +0800 CST	deployed	mychart-0.1.0   	1.16.0     
wordpress-1653960533	default  	1       	2022-05-31 09:29:00.463219 +0800 CST	deployed	wordpress-14.2.6	5.9.3   
```

- Check `myvalue`
```
$ helm get  manifest mydemo
---
# Source: mychart/templates/configmap.yaml
apiVersion: v1
data:
  myvalue: Hello World      ## --> Hello World
kind: ConfigMap
metadata:
  name: mychart-mydemo

```

## Reference:
  - https://helm.sh/docs/topics/library_charts/
