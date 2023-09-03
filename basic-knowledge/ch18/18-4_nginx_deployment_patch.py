from os import path

import yaml

from kubernetes import client, config

# refer to
# https://github.com/kubernetes-client/python/blob/master/examples/deployment_crud.py


namespace="fuming-poc"

config.load_kube_config()
with open(path.join(path.join(path.dirname(__file__), "nginx-deployment.yaml"))) as f:
  dep = yaml.safe_load(f)
  k8s_app_v1 = client.AppsV1Api()
  dep['spec']['replicas']=3
  resp = k8s_app_v1.patch_namespaced_deployment(name="nginx-deployment", body=dep,  namespace=namespace)

