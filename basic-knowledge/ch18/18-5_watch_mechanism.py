from kubernetes import client, config, watch

#
# refer to https://github.com/kubernetes-client/python/blob/master/examples/watch/pod_namespace_watch.py
#
# Use Ctrl + C to exit

config.load_kube_config()
v1=client.CoreV1Api()

w=watch.Watch()
namespace_name="fuming-poc"

for e in w.stream(v1.list_namespaced_pod, namespace_name):
  print(e)
