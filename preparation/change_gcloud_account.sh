#!/bin/sh

# [compute]
#region = asia-southeast1
#zone = asia-southeast1-b
#[container]
#cluster = ggv-k8s-non-production2-sg
#[core]
#account = fuming.tsai@gogox.com
#disable_usage_reporting = False
#project = gogovan-dev-f3dc6

echo "Which project do you want to use? 1. gogox-analytics-non-prod 2. ggv-k8s-non-production2-sg"
read choice


if [[ "$choice" = "1" ]]; then
    echo "Project: gogox-analytics-non-prod"
    gcloud config set compute/zone asia-southeast1-a
    gcloud config set project gogox-analytics-non-prod
    gcloud config set container/cluster gogox-analytics-non-prod-fuming-gke
    gcloud container clusters get-credentials gogox-analytics-non-prod-fuming-gke
elif [[ "$choice" = "2" ]]; then
    echo "Project: ggv-k8s-non-production2-sg"
    gcloud config set compute/zone asia-southeast1-b
    gcloud config set project gogovan-dev-f3dc6
#   gcloud config set container/cluster ggv-k8s-non-production2-sg
    gcloud container clusters get-credentials ggv-k8s-non-production2-sg
else
    echo "Your input:$choice is not valid."
fi
exit 0




