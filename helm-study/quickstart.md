## Quickstart
- add a chart repo
```
 $ helm repo add bitnami https://charts.bitnami.com/bitnami
```
- list charts in repo
```
 $ helm search repo bitnami
NAME                                        	CHART VERSION	APP VERSION  	DESCRIPTION                                       
bitnami/bitnami-common                      	0.0.9        	0.0.9        	DEPRECATED Chart with custom templates used in ...
bitnami/airflow                             	12.0.16      	2.2.4        	Apache Airflow is a tool to express and execute...
bitnami/apache                              	9.0.13       	2.4.53       	Apache HTTP Server is an open-source HTTP serve...
bitnami/argo-cd                             	3.1.7        	2.3.2        	Argo CD is a continuous delivery tool for Kuber...
bitnami/argo-workflows                      	1.1.2        	3.3.1        	Argo Workflows is meant to orchestrate Kubernet...
bitnami/aspnet-core                         	3.1.13       	6.0.3        	ASP.NET Core is an open-source framework for we...
bitnami/cassandra                           	9.1.13       	4.0.3        	Apache Cassandra is an open source distributed ...
bitnami/cert-manager                        	0.4.11       	1.7.2        	Cert Manager is a Kubernetes add-on to automate...
bitnami/common                              	1.13.0       	1.13.0       	A Library Helm Chart for grouping common logic ...
bitnami/concourse                           	1.0.12       	7.7.1        	Concourse is an automation system written in Go...
....
```
- update repo
```
 $ helm repo update
```

- install a sample chart
```
 $ helm install bitnami/mysql --generate-name
NAME: mysql-1652231623
LAST DEPLOYED: Wed May 11 09:13:50 2022
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

  echo Primary: mysql-1652231623.default.svc.cluster.local:3306

Execute the following to get the administrator credentials:

  echo Username: root
  MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default mysql-1652231623 -o jsonpath="{.data.mysql-root-password}" | base64 --decode)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run mysql-1652231623-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.29-debian-10-r2 --namespace default --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash

  2. To connect to primary service (read/write):

      mysql -h mysql-1652231623.default.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"



To upgrade this helm chart:

  1. Obtain the password as described on the 'Administrator credentials' section and set the 'root.password' parameter as shown below:

      ROOT_PASSWORD=$(kubectl get secret --namespace default mysql-1652231623 -o jsonpath="{.data.mysql-root-password}" | base64 --decode)
      helm upgrade --namespace default mysql-1652231623 bitnami/mysql --set auth.rootPassword=$ROOT_PASSWORD
```
- verify
```
 $ helm status mysql-1652232545
NAME: mysql-1652232545
LAST DEPLOYED: Wed May 11 09:29:10 2022
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

  echo Primary: mysql-1652232545.default.svc.cluster.local:3306

Execute the following to get the administrator credentials:

  echo Username: root
  MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default mysql-1652232545 -o jsonpath="{.data.mysql-root-password}" | base64 --decode)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run mysql-1652232545-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.29-debian-10-r2 --namespace default --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash

  2. To connect to primary service (read/write):

      mysql -h mysql-1652232545.default.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"



To upgrade this helm chart:

  1. Obtain the password as described on the 'Administrator credentials' section and set the 'root.password' parameter as shown below:

      ROOT_PASSWORD=$(kubectl get secret --namespace default mysql-1652232545 -o jsonpath="{.data.mysql-root-password}" | base64 --decode)
      helm upgrade --namespace default mysql-1652232545 bitnami/mysql --set auth.rootPassword=$ROOT_PASSWORD

```
- get information about chart `mysql`. Please note `mysql` does not need to be install on k8s. 

```
 $ helm show chart bitnami/mysql
annotations:
  category: Database
apiVersion: v2
appVersion: 8.0.29
dependencies:
- name: common
  repository: https://charts.bitnami.com/bitnami
  tags:
  - bitnami-common
  version: 1.x.x
description: MySQL is a fast, reliable, scalable, and easy to use open source relational
  database system. Designed to handle mission-critical, heavy-load production applications.
home: https://github.com/bitnami/charts/tree/master/bitnami/mysql
icon: https://bitnami.com/assets/stacks/mysql/img/mysql-stack-220x234.png
keywords:
- mysql
- database
- sql
- cluster
- high availability
maintainers:
- email: containers@bitnami.com
  name: Bitnami
name: mysql
sources:
- https://github.com/bitnami/bitnami-docker-mysql
- https://mysql.com
version: 8.9.6

```
- get all info about mysql chart

```
 $ helm show all bitnami/mysql
```

- list down all release
```
 $ helm list
NAME            	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART      	APP VERSION
mysql-1652231623	default  	1       	2022-05-11 09:13:50.515179 +0800 CST	deployed	mysql-8.9.6	8.0.29     

 $ helm ls
NAME            	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART      	APP VERSION
mysql-1652231623	default  	1       	2022-05-11 09:13:50.515179 +0800 CST	deployed	mysql-8.9.6	8.0.29     

```

- uninstall a release

```
 $ helm uninstall mysql-1652232545 --keep-history      # if we have the option "--keep-history "
release "mysql-1652232545" uninstalled

 $ helm status mysql-1652232545   # we can still search for the status and its status = uninstalled
NAME: mysql-1652232545
LAST DEPLOYED: Wed May 11 09:29:10 2022
NAMESPACE: default
STATUS: uninstalled
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: mysql
CHART VERSION: 8.9.6
APP VERSION: 8.0.29

** Please be patient while the chart is being deployed **

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace default
```

- rollback
```
 $  helm rollback  mysql-1652232545

```

- get help
```
 $ helm get -h
```

## References
- [Quick Start(English)](https://docs.helm.sh/docs/intro/quickstart/) 
- [Quick Start(中文版)](https://helm.sh/zh/docs/intro/install/)
