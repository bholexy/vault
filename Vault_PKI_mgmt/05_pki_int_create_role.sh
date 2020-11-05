#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=root
export VAULT_NAMESPACE=

#create a role to generate new certificates
kubectl exec vault-0 -n vault -- vault write pki_int/roles/roava-dot-app \
        allowed_domains="roava.app" \
        allow_subdomains=true \
        max_ttl="720h"
#vault delete pki_int/roles/example-dot-com