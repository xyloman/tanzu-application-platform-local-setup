# Overview

## Setup Kind

There are a few options for creating using the kind [local registry enabled](https://kind.sigs.k8s.io/docs/user/local-registry/) or David Syers's [example kind-setup](https://github.com/dsyer/kpack-with-kind/blob/main/kind-setup.sh).  A copy of David's is included in this repository under file kind-setup.sh.

```bash
./kind-setup.sh
```

Example output:

```bash
No kind clusters found.
ec4d3bc60d6ca61887845203b48b2d3073cb5acce35b3e66b5190d0ae1a41a29
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.23.1) 🖼 
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
Setting up kubeconfig
configmap/local-registry-hosting created
```

This will create a kind cluster with a local registry with name `registry.local`.  This setup will allow Tanzu Application Platform running on kind to build images with Tanzu Build Service and publish them to `registry.local`.  Deployments running on the cluster will now be able to resolve the built images.

### Registry Host for local development

Similar [David's documentation](https://github.com/dsyer/kpack-with-kind#registry-host) with using `kpack` locally you will need to add the `registry.local` hostname resolvable from your host machine.  This will be useful when using a `Tilefile` locally you will need to add the `registry.local` hostname to your `/etc/hosts`.  

On Linux you can perform the following:

```bash
docker inspect -f '{{.NetworkSettings.IPAddress}} dev.local' dev.local | (sudo tee -a /etc/hosts)
```
Example output:

```bash
docker inspect -f '{{.NetworkSettings.IPAddress}} dev.local' dev.local | (sudo tee -a /etc/hosts)
172.17.0.2 dev.local
```

## Install Tanzu Application Platform on KIND

Install the pivnet-cli used to download artifacts from Tanzu Network.

### MacOS
```bash
brew install pivotal/tap/pivnet-cli
```

### Linux
This will place the pivnet cli in a folder called ~/scripts which I typically have on my PATH.

Obtain a refresh token from: https://network.pivotal.io/users/dashboard/edit-profile

```bash
./install-pivnet-cli <token_goes_here>
```

### Target k8s cluster

```bash
kubectl config use-context kind-kind
```

### Install Tanzu Application Platform

Linux:

```bash
./tanzu-cluster-essentials.sh <tanzu_net_user> <tanzu_net_password>
./tanzu-cli.sh <tanzu_net_user> <tanzu_net_password>
./tanzu-application-platform.sh <tanzu_net_user> <tanzu_net_password>
./developer-namespace.sh
```


### Install Application Service Adapter for TAP

Enables the Cloud Foundry compatible API on the k8s cluster to deliver applications using `cf push`.

Reference: https://docs.vmware.com/en/Application-Service-Adapter-for-VMware-Tanzu-Application-Platform/0.3/tas-adapter/GUID-install.html

Linux:
```bash
./tanzu-application-service-adapter.sh <tanzu_net_user> <tanzu_net_password>
```

Run the script `./tanzu-application-service-orgs.sh` to create the necessary org and space for local development with `cf push`

### Install All

Linux:

```bash
./install.sh <tanzu_net_token> <tanzu_net_user> <tanzu_net_password>
```

### Install Tanzu vscode extension

The script `./tanzu-cli.sh` will download the `tanzu-vscode-extension.vsix` to `/tmp` which corresponds to the version of Tanzu Application Platform.

Reference: https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-vscode-extension-install.html
