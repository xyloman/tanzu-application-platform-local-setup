#!/bin/bash

set +x

version=${CLUSTER_ESSENTIALS_VERSION:-1.0.0}
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

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=${tanzu_net_user}
export INSTALL_REGISTRY_PASSWORD=${tanzu_net_pass}
cd /tmp/tanzu-cluster-essentials
./install.sh

cp /tmp/tanzu-cluster-essentials/kapp ~/scripts/kapp