## Objectives
- In this folder, I put yaml files regarding how to set up PSP with validating webhook configuration.
- All examples are from https://github.com/open-policy-agent/gatekeeper-library/tree/master/library/pod-security-policy/users
- All of the content in this folder is not mentioned in the book.

## How to apply
- apply `template.yaml`.
```
$ kubectl create -f template.yaml 
constrainttemplate.templates.gatekeeper.sh/k8spspallowedusers created
```
- `template.yaml`: rego syntax

- apply `contraint.yaml`
```
$ kubectl apply -f constraint.yaml 
k8spspallowedusers.constraints.gatekeeper.sh/psp-pods-allowed-user-ranges created

```

## Let's give it a try
- test with `kuard_allowed.yaml`
```
$  kubectl apply -f kuard_allowed.yaml
pod/kuard-allowed created
```

- Let's get a shell to the running container `kuard-allowed`
```
$ kubectl get pods
NAME            READY   STATUS    RESTARTS   AGE
kuard-allowed   1/1     Running   0          3m55s

$ kubectl exec --stdin --tty kuard-allowed -- /bin/sh

/ $ ps -a       # <---- already got a shell
PID   USER     TIME  COMMAND
    1 199       0:00 /kuard
   16 199       0:00 /bin/sh
   23 199       0:00 ps -a
/ $ whoami      
whoami: unknown uid 199
```

- test with `nginx_disallowed.yaml`
```
$ kubectl create -f nginx_disallowed.yaml 
Error from server (Forbidden): error when creating "nginx_disallowed.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [psp-pods-allowed-user-ranges] Container nginx is attempting to run as disallowed group 250. Allowed fsGroup: {"ranges": [{"max": 200, "min": 100}], "rule": "MustRunAs"}
[psp-pods-allowed-user-ranges] Container nginx is attempting to run as disallowed group 250. Allowed runAsGroup: {"ranges": [{"max": 200, "min": 100}], "rule": "MustRunAs"}
[psp-pods-allowed-user-ranges] Container nginx is attempting to run as disallowed user 250. Allowed runAsUser: {"ranges": [{"max": 200, "min": 100}], "rule": "MustRunAs"}
[psp-pods-allowed-user-ranges] Container nginx is attempting to run with disallowed supplementalGroups [250]. Allowed supplementalGroups: {"ranges": [{"max": 200, "min": 100}], "rule": "MustRunAs"}
```
