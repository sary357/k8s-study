## charts folder structure
- Download wordpress

```
$ helm pull bitnami/wordpress
$ ls
README.md		wordpress-15.0.0.tgz
$ tar xzf   wordpress-15.0.0.tgz
```

- Check folder structure

```
$ ls -l wordpress
total 264
-rw-r--r--   1 sary357  staff    388  6 15 02:05 Chart.lock  
-rw-r--r--   1 sary357  staff   1033  6 15 02:05 Chart.yaml  # A yaml file containing information about this chart
-rw-r--r--   1 sary357  staff  65990  6 15 02:05 README.md   # Optional: A human-readable README file
drwxr-xr-x   5 sary357  staff    160  6 17 09:28 charts      # A folder containing charts upon which this chart depends
drwxr-xr-x  23 sary357  staff    736  6 17 09:28 templates   # A folder of template that will generate vaild k8s manifest files when combined with values. 
-rw-r--r--   1 sary357  staff   5706  6 15 02:05 values.schema.json  # A Json file which define config format used in values.yaml
-rw-r--r--   1 sary357  staff  46518  6 15 02:05 values.yaml # The default config vaules for this chart
```
```
# The following does not exist in the folder "wordpress". 
crds/: Optional: Custom resource Definition
License: Optional: A plain text file containing the license for the chart
templates/NOTES.txt:  A plain text file containing short usage notes

```
## Chart.yaml
- Format and its meaning. Take wordpress-15.0.0.tgz as an example here.

```
apiVersion: The chart API version (required).
eg:
apiVersion: v2

name: The name of the chart (required). 
eg:
name: wordpress

version: A SemVer 2 version (required.
eg:
version: 15.0.0

kubeVersion: A SemVer range of compatible Kubernetes versions (optional)

description: A single-sentence description of this project (optional). 
eg: 
description: WordPress is the world's most popular blogging and content management
  platform. Powerful yet simple, everyone from students to global corporations use
  it to build beautiful, functional websites.

type: The type of the chart (optional)
keywords:
  - A list of keywords about this project (optional)
eg:
keywords:
- application
- blog
- cms
- http
- php
- web
- wordpress

home: The URL of this projects home page (optional)
eg:
home: https://github.com/bitnami/charts/tree/master/bitnami/wordpress

sources:
  - A list of URLs to source code for this project (optional)
eg:
sources:
- https://github.com/bitnami/bitnami-docker-wordpress
- https://wordpress.org/

dependencies: # A list of the chart requirements (optional)
  - name: The name of the chart (nginx)
    version: The version of the chart ("1.2.3")
    repository: (optional) The repository URL ("https://example.com/charts") or alias ("@repo-name")
    condition: (optional) A yaml path that resolves to a boolean, used for enabling/disabling charts (e.g. subchart1.enabled )
    tags: # (optional)
      - Tags can be used to group charts for enabling/disabling together
    import-values: # (optional)
      - ImportValues holds the mapping of source values to parent key to be imported. Each item can be a string or pair of child/parent sublist items.
    alias: (optional) Alias to be used for the chart. Useful when you have to add the same chart multiple times
eg:
- condition: memcached.enabled
  name: memcached
  repository: https://charts.bitnami.com/bitnami
  version: 6.x.x
- condition: mariadb.enabled
  name: mariadb
  repository: https://charts.bitnami.com/bitnami
  version: 11.x.x
- name: common
  repository: https://charts.bitnami.com/bitnami
  tags:
  - bitnami-common
  version: 1.x.x

maintainers: # (optional)
  - name: The maintainers name (required for each maintainer)
    email: The maintainers email (optional for each maintainer)
    url: A URL for the maintainer (optional for each maintainer)
icon: A URL to an SVG or PNG image to be used as an icon (optional).
appVersion: The version of the app that this contains (optional). Needn't be SemVer. Quotes recommended.
deprecated: Whether this chart is deprecated (optional, boolean)
annotations:
  example: A list of annotations keyed by name (optional).)

```

## Reference
- `SemVer`: we can think the format of version is `major_version`.`minor_version`.`patch_number`. Eg. 1.0.13 mean major version is `1`, monir version is `0`, and patch number is `13`.
- https://helm.sh/docs/topics/charts/