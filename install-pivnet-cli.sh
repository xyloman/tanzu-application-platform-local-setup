#!/bin/bash

curl -o /tmp/pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1 -L
install /tmp/pivnet ~/scripts/pivnet
pivnet login --api-token $1