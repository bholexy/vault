#!/bin/sh
set -o xtrace
export VAULT_ADDR= $1
export VAULT_TOKEN=root
export VAULT_NAMESPACE= vault
#login into Vault 
kubectl exec vault-0 -n vault -- vault login root
#check the status of Vault server
kubectl exec vault-0 -n vault -- vault status

#enable Audit and write logs to a file
kubectl exec vault-0 -n vault -- vault audit enable file file_path=/var/log/vault_audit.log
#enable another Audit and log to another file but with raw data
kubectl exec vault-0 -n vault -- vault audit enable -path="file_raw" file  log_raw=true file_path=/var/log/vault_audit_raw.log