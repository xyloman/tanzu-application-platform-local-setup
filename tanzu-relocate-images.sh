#!/bin/bash

# Reference: https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-install.html#relocate-images-to-a-registry-0

tanzu_net_user=$1
tanzu_net_pass=$2
version=${TAP_VERSION:-1.1.0}

export INSTALL_REGISTRY_USERNAME=user
export INSTALL_REGISTRY_PASSWORD=password
export INSTALL_REGISTRY_HOSTNAME=localhost:5000
export INSTALL_REGISTRY_REPOSITORY=tanzu-application-platform

echo "Logging into ${INSTALL_REGISTRY_HOSTNAME} as ${INSTALL_REGISTRY_USERNAME}"
docker login ${INSTALL_REGISTRY_HOSTNAME} --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD}

echo "Logging into registry.tanzu.vmware.com as ${tanzu_net_user}"
docker login registry.tanzu.vmware.com --username ${tanzu_net_user} --password ${tanzu_net_pass}

echo "Relocating tap-packages from registry.tanzu.vmware.com to ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPOSITORY}/tap-packages this can take up to 15 minutes"
imgpkg copy \
  --concurrency 32 \
  --bundle registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${version} \
  --to-tar tap-packages-${version}.tar.gz

imgpkg copy \
  --concurrency 32 \
  --tar tap-packages-${version}.tar.gz \
  --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPOSITORY}/tap-packages

## Note that this might throw the following exception   UNKNOWN: unknown error; UNKNOWN: unknown error; map[]; MANIFEST_BLOB_UNKNOWN: blob unknown to registry; sha256:3a78847ea829208edc2d7b320b7e602b9d12e47689499d5180a9cc7790dec4d7 
## If it does and you are using a local docker registry set the environment variable --env REGISTRY_VALIDATION_DISABLED=true when starting up the registry

