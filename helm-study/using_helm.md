## Basic concepts
- Chart: a helm package that can be installed on k8s. We can think a chart looks like RPM installed on linux system.
- Repository: the place we can put/collect/share charts
- Release: a instance of a Chart. We can install multiple charts on the same k8s cluster. Eg, if you'd need 2 MySQL instances, you can install mysql charts twice. Each one has its own release name.

## Finding charts
- `helm search hub`: search for chart from the repositories in the [Artifact hub](https://artifacthub.io/)
```
$ helm search hub wordpress
URL                                               	CHART VERSION 	APP VERSION        	DESCRIPTION                                       
https://artifacthub.io/packages/helm/kube-wordp...	0.1.0         	1.1                	this is my wordpress package                      
https://artifacthub.io/packages/helm/bitnami/wo...	14.0.7        	5.9.3              	WordPress is the world's most popular blogging ...
https://artifacthub.io/packages/helm/bitnami-ak...	14.0.7        	5.9.3              	WordPress is the world's most popul
...
```

- `helm search repo`: search for chart from the repositories installed on local helm client (with `helm repo add`). This only search on local data and does NOT need public network.
```
$ helm repo add bitami https://charts.bitnami.com/bitnami # added a repo

$ helm search repo wordpress
NAME                   	CHART VERSION	APP VERSION	DESCRIPTION                                       
bitnami/wordpress      	14.0.7       	5.9.3      	WordPress is the world's most popular blogging ...
bitnami/wordpress-intel	1.0.6        	5.9.3      	WordPress for Intel is the most popular bloggin...
```

- fuzzy search. try to search for packages if package name contains a string `kash`
```
$ helm repo add brigade https://brigadecore.github.io/charts
"brigade" has been added to your repositories

$ helm search repo kash
NAME          	CHART VERSION	APP VERSION	DESCRIPTION                
brigade/kashti	0.7.0        	v0.4.0     	A Helm chart for Kubernetes
```

## Installing a package
- basic: `helm install YOUR_FAVORIATE_NAME PACKAGE_NAME`.

```
$ helm install happy-panda bitnami/mysql
NAME: happy-panda
LAST DEPLOYED: Fri May 13 09:24:03 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: mysql
CHART VERSION: 8.9.6
APP VERSION: 8.0.29

** Please be patient while the chart is being deployed **

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace default

Services:

  echo Primary: happy-panda-mysql.default.svc.cluster.local:3306

Execute the following to get the administrator credentials:

  echo Username: root
  MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default happy-panda-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run happy-panda-mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.29-debian-10-r2 --namespace default --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash

  2. To connect to primary service (read/write):

      mysql -h happy-panda-mysql.default.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"



To upgrade this helm chart:

  1. Obtain the password as described on the 'Administrator credentials' section and set the 'root.password' parameter as shown below:

      ROOT_PASSWORD=$(kubectl get secret --namespace default happy-panda-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)
      helm upgrade --namespace default happy-panda bitnami/mysql --set auth.rootPassword=$ROOT_PASSWORD

$ helm ls
NAME            	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART      	APP VERSION
happy-panda     	default  	1       	2022-05-13 09:24:03.864795 +0800 CST	deployed	mysql-8.9.6	8.0.29     

``` 

- You can use `--generate-name`. helm will generate a name for you.
```
$ helm install bitnami/mysql --generate-name
NAME: mysql-1652231623
LAST DEPLOYED: Wed May 11 09:13:50 2022
.....
$ helm ls
NAME            	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART      	APP VERSION
mysql-1652405170	default  	1       	2022-05-13 09:26:15.721213 +0800 CST	deployed	mysql-8.9.6	8.0.29     

```

- because helm won't wait until everything is installed. we can use `helm status` to know current release state

```
$ helm status happy-pandas

```
$ helm status happy-panda
NAME: happy-panda
LAST DEPLOYED: Fri May 13 09:24:03 2022
NAMESPACE: default
STATUS: deployed
...
...
...
```

## Customizing the Chart Before Installing
- show what options are configurable
```
$ helm show values bitnami/wordpress
## @section Global parameters
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry, imagePullSecrets and storageClass
##

## @param global.imageRegistry Global Docker image registry
## @param global.imagePullSecrets Global Docker registry secret names as an array
## @param global.storageClass Global StorageClass for Persistent Volume(s)
##
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  storageClass: ""

## @section Common parameters
##

## @param kubeVersion Override Kubernetes version
##
kubeVersion: ""
...
```

- override default setting. db name: user0db, user name: user0
```
$ echo '{mariadb.auth.database: user0db, mariadb.auth.username: user0}' > values.yaml
$ helm install -f values.yaml bitnami/wordpress --generate-name
```

- `'{outer.name1: value1, outer.name2: value2}'` is equivalent of
```
outer:
  name1: value1
  name2: value2
```

- `'{servers[0].port=80}'` is equivalent of
```
servers:
  - port: 80
```

- `'{servers[0].port 80, servers[0].host example}'`
```
servers:
  - port: 80
    host: example
```
