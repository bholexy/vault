#!/bin/sh
set -o xtrace
export VAULT_ADDR=https://34.121.62.102:8200/
export VAULT_TOKEN=root
export VAULT_NAMESPACE=

#enable Vault PKI secret engine 
kubectl exec vault-0 -n vault -- vault secrets enable pki

#set default ttl
kubectl exec vault-0 -n vault -- vault secrets tune -max-lease-ttl=87600h pki

#generate root CA
kubectl exec vault-0 -n vault -- vault write -format=json pki/root/generate/internal \
common_name="roava.app" ttl=8760h  > pki-ca-root.json

#save the certificate in a sepearate file, we will add it later as trusted to our browser/computer
cat pki-ca-root.json | jq -r .data.certificate > ca.pem

#publish urls for the root ca
kubectl exec vault-0 -n vault -- vault write pki/config/urls \
        issuing_certificates="https://34.123.1.232:8200/v1/pki/ca" \
        crl_distribution_points="https://34.123.1.232:8200/v1/pki/crl"

#vault secrets disable pki

