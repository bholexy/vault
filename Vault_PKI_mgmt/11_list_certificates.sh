#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=`cat user.token`

#list all certificates created by the intermediate CA
kubectl exec vault-0 -n vault -- vault list pki_int/certs
kubectl exec vault-0 -n vault -- vault list pki_int/certs > cert_key_list

