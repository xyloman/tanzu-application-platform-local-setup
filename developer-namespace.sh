# Based upon: https://docs.vmware.com/en/Tanzu-Application-Platform/1.0/tap/GUID-install-components.html#setup

#!/bin/bash

namespace=${DEVELOPER_NAMESPACE:-default}

tanzu secret registry add registry-credentials \
  --server dev.local:5000 \
  --username user \
  --password password \
  --namespace ${namespace}

kubectl --namespace ${namespace} apply --filename developer-namespace.yml