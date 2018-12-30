#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_DIR/set-kubeconfig.sh

# Storage
set +x
echo "----------------------------<<< ADD STORAGE >>>-------------------------------"
set -x
kubectl apply -f storage/nfs-psp.yml
kubectl apply -f storage/nfs-rbac.yml
kubectl apply -f storage/nfs-deployment.yml
kubectl patch storageclass example-nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Ingress
set +x
echo "----------------------------<<< ADD INGRESS >>>-------------------------------"
set -x
kubectl apply -f ingress/kube-nginx-ingress-controller.yml

# Monitoring
set +x
echo "----------------------------<<< ADD MONITORING >>>-------------------------------"
set -x

kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl create -f monitoring/manifests/ || true

# It can take a few seconds for the above 'create manifests' command to fully create the following resources, so verify the resources are ready before proceeding.
until kubectl get customresourcedefinitions servicemonitors.monitoring.coreos.com ; do date; sleep 1; echo ""; done
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

kubectl create -f monitoring/manifests/ 2>/dev/null || true  # This command sometimes may need to be done twice (to workaround a race condition).

# Ease demos by disabling authentication for dashboard
# See: https://stackoverflow.com/questions/46664104/how-to-sign-in-kubernetes-dashboard
# Open up dashboard access
kubectl apply -f dashboard/skip-auth.yaml


