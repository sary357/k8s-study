from kubernetes import client, config
from kubernetes.stream import stream

# refer to https://github.com/kubernetes-client/python/blob/master/examples/pod_exec.py
# Assume pod name = "myapp" and namespace name = "funming-poc"
# execute a command: ls /usr in the POD

config.load_kube_config()
api=client.CoreV1Api()
namespace_name="fuming-poc"
pod_name="myapp"
#pod_manifest = {
#  "apiVersion": "v1",
#  "kind":"Pod",
#  "metadata":{
#    "name":"myapp"
#  },
#  "spec": {
#    "containers":[{
#      "image":"nginx",
#      "name":"sleep",
#    }]
#  }
#}

# resp=api.create_namespaced_pod(body=pod_manifest, namespace=namespace)

cmd= ['ls', '/usr']
resp=stream(api.connect_get_namespaced_pod_exec,
           name=pod_name,
           namespace=namespace_name,
           command=cmd,
           stderr=True,
           stdin=False,
           stdout=True,
           tty=False)
print("Response: " + resp)
