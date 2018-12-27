### kube-prometheus
This monitor is using the generated yml files from [kube-prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus) :

The files are stored in the manifests subdirectory. 

The projects provides monitoring via Prometheus, Grafana and Alert Manager.

##### Installation
This monitor is installed with the install-all-features.sh script.

##### Usage Grafana
Locally create a port-forward :
```
kubectl -n monitoring port-forward service/grafana 3000
```
and point your browser to http://127.0.0.1:3000

##### Usage Prometheus
Locally create a port-forward :
```
kubectl -n monitoring port-forward service/prometheus-k8s 9090
```
and point your browser to http://127.0.0.1:9090

##### Alert Manager
Locally create a port-forward :
```
kubectl -n monitoring port-forward service/alertmanager-main 9093
```
and point your browser to http://127.0.0.1:9093

### weavescope
This monitor automatically generates a map of your application, enabling you to intuitively understand, monitor, and control your containerized, microservices based applicationThis is a visual add-on to heaster and is using this image :
- [scope v1.6.7](https://hub.docker.com/r/weaveworks/scope/)
##### Installation
Install with kubectl :
```
kubectl apply --namespace kube-system -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
##### Usage
Locally create a port-forward :
```
kubectl port-forward -n kube-system "$(kubectl get -n kube-system pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040
```
and point your browser to http://127.0.0.1:4040 