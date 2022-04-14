#!/bin/bash

set +x

# Reference: https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.1/cluster-essentials/GUID-deploy.html

version=${CLUSTER_ESSENTIALS_VERSION:-1.1.0}
glob=${CLUSTER_ESSENTIALS_GLOB:-tanzu-cluster-essentials-linux-amd64-*.tgz}
tanzu_net_user=$1
tanzu_net_pass=$2

pivnet download-product-files \
  --product-slug tanzu-cluster-essentials \
  --release-version ${version} \
  --glob ${glob} \
  --download-dir /tmp

rm -fr /tmp/tanzu-cluster-essentials
mkdir /tmp/tanzu-cluster-essentials
cat /tmp/${glob} | tar -xvzf - -i -C /tmp/tanzu-cluster-essentials

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:ab0a3539da241a6ea59c75c0743e9058511d7c56312ea3906178ec0f3491f51d
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=${tanzu_net_user}
export INSTALL_REGISTRY_PASSWORD=${tanzu_net_pass}

cd /tmp/tanzu-cluster-essentials
./install.sh --yes

install /tmp/tanzu-cluster-essentials/kapp ~/scripts/kapp
install /tmp/tanzu-cluster-essentials/imgpkg ~/scripts/imgpkg
install /tmp/tanzu-cluster-essentials/kbld ~/scripts/kbld
install /tmp/tanzu-cluster-essentials/ytt ~/scripts/ytt