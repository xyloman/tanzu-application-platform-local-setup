#!/bin/bash

# https://docs.vmware.com/en/Application-Service-Adapter-for-VMware-Tanzu-Application-Platform/0.3/tas-adapter/GUID-install.html

export INSTALL_REGISTRY_USERNAME=$1
export INSTALL_REGISTRY_PASSWORD=$2
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
version=0.3.0
tas_domain=local.cernerpinzon.com

kubectl create ns tas-adapter-install

tanzu secret registry add tanzunet-registry \
  --username ${INSTALL_REGISTRY_USERNAME} \
  --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces \
  --namespace tas-adapter-install \
  --yes \

tanzu package repository add tas-adapter-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/app-service-adapter/tas-adapter-package-repo:${version} \
  --namespace tas-adapter-install

tanzu package available list --namespace tas-adapter-install

openssl req -x509 -newkey rsa:4096 \
  -keyout tas-tls-api.key -out tas-tls-api.crt \
  -nodes -subj "/CN=api.sys.${tas_domain}" \
  -addext "subjectAltName = DNS:api.sys.${tas_domain}" \
  -days 365

openssl req -x509 -newkey rsa:4096 \
  -keyout tas-tls-apps.key -out tas-tls-apps.crt \
  -nodes -subj "/CN=*.apps.${tas_domain}" \
  -addext "subjectAltName = DNS:*.apps.${tas_domain}" \
  -days 365

cp tas-adapter-values-template.yml tas-adapter-values.yml
yq w -i tas-adapter-values.yml 'api_ingress.fqdn' "api.sys.${tas_domain}"
yq w -i tas-adapter-values.yml 'api_ingress.tls.crt' -- "$(cat tas-tls-api.crt)"
yq w -i tas-adapter-values.yml 'api_ingress.tls.key' -- "$(cat tas-tls-api.key)"

yq w -i tas-adapter-values.yml 'app_ingress.default_domain' "apps.${tas_domain}"
yq w -i tas-adapter-values.yml 'app_ingress.tls.crt' -- "$(cat tas-tls-apps.crt)"
yq w -i tas-adapter-values.yml 'app_ingress.tls.key' -- "$(cat tas-tls-apps.key)"

tanzu package installed update tas-adapter \
  --package-name application-service-adapter.tanzu.vmware.com \
  --version ${version} \
  --values-file tas-adapter-values.yml \
  --namespace tas-adapter-install \
  --install

rm tas-adapter-values.yml

tanzu package installed list --namespace tas-adapter-install