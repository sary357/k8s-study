from kubernetes import client, config

##
##
# list PODs from 1) all namespaces and 2) from the namespace "fuming-poc"

config.load_kube_config()
api=client.CoreV1Api()

pod_list=api.list_pod_for_all_namespaces(watch=False)
for pod in pod_list.items:
    print("%s\t%s\t%s" % (pod.status.pod_ip, pod.metadata.namespace, pod.metadata.name))

## only list POD in the namespace: fuming-poc
print("-" * 20)
namespace="fuming-poc"
pod_list=api.list_namespaced_pod(namespace)
for pod in pod_list.items:
    print("%s\t%s\t%s" % (pod.status.pod_ip, pod.metadata.namespace, pod.metadata.name))
