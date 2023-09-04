from kubernetes import client, config, watch

#
# refer to https://github.com/kubernetes-client/python/blob/master/examples/watch/pod_namespace_watch.py
#
# use watch to stream information through k8s APIs
# Use Ctrl + C to exit

config.load_kube_config()
api=client.CoreV1Api()

w=watch.Watch()
namespace_name="fuming-poc"

for e in w.stream(api.list_namespaced_pod, namespace_name):
  print(e)
