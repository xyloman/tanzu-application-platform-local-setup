#!/bin/bash

# delete kind cluster
kind delete cluster

# clean up the local registry
docker stop dev.local
docker rm dev.local
docker system prune --volumes