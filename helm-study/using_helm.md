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
$ helm status happy-panda
NAME: happy-panda
LAST DEPLOYED: Fri May 13 09:24:03 2022
NAMESPACE: default
STATUS: deployed

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

## helm upgrade and helm rollback
- current installation
```
$ helm ls
NAME                	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART           	APP VERSION
wordpress-1652666276	default  	1       	2022-05-16 09:58:02.115471 +0800 CST	deployed	wordpress-14.0.7	5.9.3      

$ helm get values wordpress-1652666276
USER-SUPPLIED VALUES:
mariadb.auth.database: user0db
mariadb.auth.username: user0

```

- we have a file called `panda.yaml`. The following is the content
```
$ cat panda.yaml 
mariadb.auth.username: user1
```

- helm only preform the least invasive(侵入性) upgrade. It only update parts that changed in the latest release.
```
$ helm upgrade -f panda.yaml wordpress-1652666276 bitnami/wordpress
Release "wordpress-1652666276" has been upgraded. Happy Helming!
NAME: wordpress-1652666276
LAST DEPLOYED: Tue May 17 09:20:46 2022
NAMESPACE: default
STATUS: deployed
REVISION: 2
.......

```

- Let's check with `helm get values wordpress-1652666276`
```
$ helm get values wordpress-1652666276
USER-SUPPLIED VALUES:
mariadb.auth.username: user1
```

- we can use `helm rollback REVISION` to rollback to previous version.
```
$ helm rollback wordpress-1652666276 1
Rollback was a success! Happy Helming!

$ helm get values wordpress-1652666276
USER-SUPPLIED VALUES:
mariadb.auth.database: user0db
mariadb.auth.username: user0

$ helm status  wordpress-1652666276
NAME: wordpress-1652666276
LAST DEPLOYED: Tue May 17 09:22:02 2022
NAMESPACE: default
STATUS: deployed
REVISION: 3       ----------------------> it become 3, not 1
TEST SUITE: None

```

- everytime we install/upgrade/rollback, the revision number is incremented by 1. The 1st revision is always `1`

- we can see revision number with the command `helm history RELEASE`
```
$ helm history  wordpress-1652666276
REVISION	UPDATED                 	STATUS    	CHART           	APP VERSION	DESCRIPTION     
1       	Mon May 16 09:58:02 2022	superseded	wordpress-14.0.7	5.9.3      	Install complete
2       	Tue May 17 09:20:46 2022	superseded	wordpress-14.0.7	5.9.3      	Upgrade complete
3       	Tue May 17 09:22:02 2022	deployed  	wordpress-14.0.7	5.9.3      	Rollback to 1   

```
## helm uninstall
- We can uninstall a release with `helm uninstall RELEASE`
```
$ helm ls # current release list
NAME                	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART           	APP VERSION
wordpress-1652666276	default  	3       	2022-05-17 09:22:02.745246 +0800 CST	deployed	wordpress-14.0.7	5.9.3      

$ helm uninstall wordpress-1652666276          # uninstall wordpress-1652666276 
release "wordpress-1652666276" uninstalled

$ helm ls     # wordpress-1652666276 has been uninstalled
NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION

```

- You can use `--keep-history` to keep installation history
```
$ helm ls
NAME                	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART           	APP VERSION
wordpress-1652751577	default  	1       	2022-05-17 09:39:42.309913 +0800 CST	deployed	wordpress-14.0.7	5.9.3      

$ helm uninstall wordpress-1652751577 --keep-history 
release "wordpress-1652751577" uninstalled

$ helm list --uninstalled
NAME                	NAMESPACE	REVISION	UPDATED                             	STATUS     	CHART           	APP VERSION
wordpress-1652751577	default  	1       	2022-05-17 09:39:42.309913 +0800 CST	uninstalled	wordpress-14.0.7	5.9.3      

```

- `helm list --all` will list 1. uninstalled release with `--keep-history` and 2. failed release
```
$ helm list --all
NAME                	NAMESPACE	REVISION	UPDATED                             	STATUS     	CHART           	APP VERSION
mysql-1652232545    	default  	1       	2022-05-11 09:29:10.938394 +0800 CST	uninstalled	mysql-8.9.6     	8.0.29     
mysql-1652233462    	default  	1       	2022-05-11 09:44:27.587542 +0800 CST	uninstalled	mysql-8.9.6     	8.0.29     
wordpress-1652751577	default  	1       	2022-05-17 09:39:42.309913 +0800 CST	uninstalled	wordpress-14.0.7	5.9.3    
```

## helm repo
- `helm repo list`: list repo
```
$ helm repo list
NAME   	URL                                 
bitnami	https://charts.bitnami.com/bitnami  
brigade	https://brigadecore.github.io/charts
```

- `helm repo add `: add a repo
```
$ helm repo add dev https://example.com/dev-charts
```

- `helm repo update`: sync remote repo to local
```
$ helm repo update bitnami
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈

```

## Reference
- https://docs.helm.sh/docs/intro/using_helm/
