#!/bin/bash

version=${TANZU_APPLICATION_PLATFORM_VERSION:-1.0.1}
glob=tanzu-framework-linux-amd64.tar

# Based on: https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-install-general.html#update-prev-tap-tanzu-cli

rm -rf /tmp/tanzu-cli           # Remove previously downloaded cli files
rm ~/scripts/tanzu              # Remove CLI binary (executable)
rm -rf ~/.config/tanzu/         # current location # Remove config directory
rm -rf ~/.tanzu/                # old location # Remove config directory
rm -rf ~/.cache/tanzu           # remove cached catalog.yaml
mkdir /tmp/tanzu-cli

pivnet download-product-files \
  --product-slug tanzu-application-platform \
  --release-version ${version} \
  --glob ${glob} \
  --download-dir /tmp

tar -xvf /tmp/${glob} -C /tmp/tanzu-cli

cd /tmp/tanzu-cli
install cli/core/v0.*/tanzu-core-linux_amd64 ~/scripts/tanzu
tanzu version
tanzu plugin install --local cli all
tanzu plugin list

pivnet download-product-files \
  --product-slug tanzu-application-platform \
  --release-version ${version} \
  --glob tanzu-vscode-extension.vsix \
  --download-dir /tmp