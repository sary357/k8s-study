from kubernetes import client, config, watch

## In this example, I assume I have a pod called myapp
# read log


config.load_kube_config()
api=client.CoreV1Api()

namespace_name="fuming-poc"
pod_name="myapp"
log= api.read_namespaced_pod_log(namespace=namespace_name, name=pod_name)
