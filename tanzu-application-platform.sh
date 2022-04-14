#!/bin/bash

tanzu_net_user=$1
tanzu_net_pass=$2
version=${TAP_VERSION:-1.1.0}

export INSTALL_REGISTRY_USERNAME=user
export INSTALL_REGISTRY_PASSWORD=password
export INSTALL_REGISTRY_HOSTNAME=dev.local:5000

kubectl create namespace tap-install
tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} \
  --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces \
  --namespace tap-install \
  --yes

tanzu secret registry add tanzunet-registry \
  --username ${tanzu_net_user} \
  --password ${tanzu_net_pass} \
  --server registry.tanzu.vmware.com \
  --export-to-all-namespaces \
  --namespace tap-install \
  --yes

tanzu package repository add tanzu-tap-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/tanzu-application-platform/tap-packages:$version \
  --namespace tap-install

tanzu package available list --namespace tap-install

cp tap-values-template.yml tap-values.yml
yq w -i tap-values.yml 'buildservice.tanzunet_username' "${tanzu_net_user}"
yq w -i tap-values.yml 'buildservice.tanzunet_password' "${tanzu_net_pass}"

tanzu package installed update tap \
  --package-name tap.tanzu.vmware.com \
  --version ${version} \
  --values-file tap-values.yml \
  --namespace tap-install \
  --install

rm tap-values.yml

tanzu package installed list --namespace tap-install