# Command I use
- make sure current config

```
 $ gcloud config list
[compute]
region = asia-southeast1
zone = asia-southeast1-a
[core]
account = xxxxxx@xxxxx.xxx
disable_usage_reporting = False
project = xxxxxxxxxx

```

- set up config (ex: zone)
```
 $ gcloud config set compute/zone asia-southeast1-a
```

- list current projects 
```
 $ gcloud projects list
```

- set up project 
```
 $ gcloud config set project xxxxxx
```

- create a GKE cluster (project name=fuming-poc-cluster)
```
 $ gcloud container clusters create fuming-poc-cluster  --zone=asia-southeast1-a --service-account=kubernetes@gogox-analytics-non-prod.iam.gserviceaccount.com  --release-channel=rapid  --machine-type=n1-standard-2
```

- list GKE clusters
```
 $ gcloud container clusters list
```

- get credential (proejct name=fuming-poc-cluster)
```
 $ gcloud container clusters get-credentials fuming-poc-cluster
```

- execute some kubectl commands (like get pods)
```
 $ kubectl get pods
```
