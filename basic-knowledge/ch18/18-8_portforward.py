from kubernetes import client, config
from kubernetes.stream import portforward
import select

# Refer to
# https://github.com/kubernetes-client/python/blob/master/examples/pod_portforward.py
#
# Assume pod name = "myapp" and namespace name = "funming-poc"
# use Port-forward

namespace_name="fuming-poc"
pod_name="myapp"

config.load_kube_config()
api_instance=client.CoreV1Api()

pf=portforward(api_instance.connect_get_namespaced_pod_portforward, 
               name=pod_name, 
               namespace=namespace_name,
               ports='80')

http = pf.socket(80)
http.setblocking(True)
http.sendall(b'GET / HTTP/1.1\r\n')
http.sendall(b'Host: 127.0.0.1\r\n')
http.sendall(b'Connection: close\r\n')
http.sendall(b'Accept: */*\r\n')
http.sendall(b'\r\n')
response = b''
while True:
    select.select([http], [], [])
    data = http.recv(1024)
    if not data:
        break
    response += data
http.close()
print(response.decode('utf-8'))
error = pf.error(80)
if error is None:
    print("No port forward errors on port 80.")
else:
    print("Port 80 has the following error: %s" % error)
