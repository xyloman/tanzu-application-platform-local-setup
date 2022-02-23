#!/bin/bash

# https://docs.vmware.com/en/Application-Service-Adapter-for-VMware-Tanzu-Application-Platform/0.3/tas-adapter/GUID-getting-started.html

alias cf=cf8
export CF_HOME=/tmp/local_cf
cf api api.sys.local.cernerpinzon.com --skip-ssl-validation
cf login

cf create-org groundworks
cf target -o groundworks
cf create-space local-dev
cf target -s local-dev

# how to view logs for a CF application
# kubectl logs -l "workloads.cloudfoundry.org/app-guid=$(cf app demo --guid)" -n "$(cf space local-dev --guid)"

# to set the current default namespace you can do this: 
# kubectl config set-context --current --namespace="$(cf space local-dev --guid)"

# find cloud native builds for an application: 
# kubectl get builds -l "workloads.cloudfoundry.org/app-guid=$(cf app demo --guid)" 