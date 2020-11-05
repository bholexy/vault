#!/bin/sh
set -o xtrace
export VAULT_ADDR=https://34.121.62.102:8200
export VAULT_TOKEN=root
export VAULT_NAMESPACE=
export VAULT_USER="kapil"
export VAULT_PASSWORD="secret"
#enable userpass to create an authentication method for creating and managing the certificates
kubectl exec vault-0 -n vault -- vault auth enable userpass

#create a new username and password with the policy we created earlier
kubectl exec vault-0 -n vault -- vault write auth/userpass/users/admin \
    password="8iu7*IU&" \
    token_policies="pki_int"

#vault auth disable userpass


