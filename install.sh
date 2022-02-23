#!/bin/bash

kind_cluster_name=${KIND_CLUSTER_NAME:-kind}
pivnet_token=$1
tanzu_net_user=$2
tanzu_net_pass=$3

./kind-setup.sh

docker inspect -f '{{.NetworkSettings.IPAddress}} dev.local' dev.local | (sudo tee -a /etc/hosts)

kubectl config use-context kind-${kind_cluster_name}

./tanzu-cluster-essentials.sh ${tanzu_net_user} ${tanzu_net_pass}
./tanzu-cli.sh
./tanzu-application-platform.sh ${tanzu_net_user} ${tanzu_net_pass}
./developer-namespace.sh
./tanzu-application-service-adapter.sh ${tanzu_net_user} ${tanzu_net_pass}