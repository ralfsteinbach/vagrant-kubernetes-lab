#!/bin/bash
echo "-----------------------------------------------------------------------------"
echo "----------------------------<<< SETUP-ISTIO >>>-------------------------------"
echo "-----------------------------------------------------------------------------"
set -e -x

KUBE_VERSION=$1
ISTIO_VERSION=$2

echo "Downloading istio version: $ISTIO_VERSION"
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=$ISTIO_VERSION  sh -

echo "Installing istio credential configuration"
cd istio-$ISTIO_VERSION
#kubectl apply -f install/kubernetes/helm/istio/templates/crds.yaml
#kubectl apply -f install/kubernetes/helm/istio/charts/certmanager/templates/crds.yaml

# Wait for tiller pod to be ready...
sleep 30

echo "Installing istio..."
helm install install/kubernetes/helm/istio --name istio --namespace istio-system --set grafana.enabled=true,servicegraph.enabled=true,tracing.enabled=true
kubectl label namespace default istio-injection=enabled

echo "Istio installed."
