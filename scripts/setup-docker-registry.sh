#!/bin/bash
echo "-----------------------------------------------------------------------------"
echo "----------------------------<<< SETUP-Docker-Registry >>>--------------------"
echo "-----------------------------------------------------------------------------"
set -e -x

mkdir -p /etc/docker/registry

cat <<EOF >/etc/docker/registry/config.yml
version: 0.1
log:
  fields:
    service: registry
storage:
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
EOF

docker run \
  -d \
  --restart=always \
  --name registry \
  -v /etc/docker/registry/config.yml:/etc/docker/registry/config.yml \
  -v /etc/kubernetes/pki/ca.crt:/certs/domain.crt \
  -v /etc/kubernetes/pki/ca.key:/certs/domain.key \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -p 5000:5000 \
  registry:2
