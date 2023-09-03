from kubernetes import client, config

# refer to https://github.com/kubernetes-client/python/blob/master/examples/pod_exec.py

config.load_kube_config()
api=client.CoreV1Api()
namespace="fuming-poc"

pod_manifest = {
  "apiVersion": "v1",
  "kind":"Pod",
  "metadata":{
    "name":"myapp"
  },
  "spec": {
    "containers":[{
      "image":"nginx",
      "name":"sleep",
    }]
  }
}

resp=api.create_namespaced_pod(body=pod_manifest, namespace=namespace)
