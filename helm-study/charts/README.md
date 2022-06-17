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


## Reference
- `SemVer`: we can think the format of version is `major_version`.`minor_version`.`patch_number`. Eg. 1.0.13 mean major version is `1`, monir version is `0`, and patch number is `13`.
- https://helm.sh/docs/topics/charts/
