#!/bin/bash
echo "-----------------------------------------------------------------------------"
echo "----------------------------<<< SETUP-NODE >>>-------------------------------"
echo "-----------------------------------------------------------------------------"
set -e -x

KUBE_VERSION=$1
BOX_NAME=$2
BOX_ETH1=$3
KUBE_APT_VERSION=

if [ -n "$KUBE_VERSION" ]; then
    if [ "$KUBE_VERSION" != "latest" ]; then
        KUBE_APT_VERSION="=$KUBE_VERSION-00 --allow-downgrades"
    fi
fi
if [ -z "$BOX_NAME" ]; then
    echo "Expected to receive the box name as second parameter"
fi
if [ -z "$BOX_ETH1" ]; then
    echo "Expected to receive the box eth1 as third parameter"
fi

# Inject our IP into the /etc/hosts in order to fix issues with VirtualBox networking
sed "s/127\.0\.0\.1.*k8s.*/$BOX_ETH1   $BOX_NAME/" -i /etc/hosts

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Install required software to run a kubernetes cluster
apt-get update && apt-get install -y apt-transport-https software-properties-common #python-software-properties

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

apt-get update
apt-get upgrade -y

# install docker
apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 18.09 | head -1 | awk '{print $3}') \

apt-get install -y kubelet$KUBE_APT_VERSION \
                   kubeadm$KUBE_APT_VERSION \
                   kubectl$KUBE_APT_VERSION  \
                   kubernetes-cni \
                   nfs-common \
                   curl \
                   htop \
                   vim

# Allow docker usage for vagrant user
sudo usermod -aG docker vagrant

# install helm client
curl --silent https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Add the kubernetes config to our profile in order to use the kubectl command without specifying it.
echo "export KUBECONFIG=/vagrant/kubeconfig/admin.conf" >> /etc/profile.d/kubernetes.sh
