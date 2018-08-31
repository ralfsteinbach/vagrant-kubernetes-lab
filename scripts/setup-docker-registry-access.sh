#!/bin/bash
echo "-----------------------------------------------------------------------------"
echo "----------------------------<<< Setup-Docker-Registry-Access>>>--------------"
echo "-----------------------------------------------------------------------------"
set -e -x

MASTER_NAME=$1
MASTER_ETH1=$2

echo "Allow insecure registries"
cat <<EOF >/etc/docker/daemon.json
{
  "insecure-registries" : ["k8smaster:5000"]
}
EOF

echo "Add $MASTER_NAME to hosts file"
echo "$MASTER_ETH1   $MASTER_NAME" >> /etc/hosts

echo "Restart docker service to make changes take effect"
service docker restart