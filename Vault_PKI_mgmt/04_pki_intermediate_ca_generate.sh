#!/bin/sh
set -o xtrace
export VAULT_ADDR=https://34.121.62.102:8200
export VAULT_TOKEN=root
export VAULT_NAMESPACE=

#enable pki secret engine for intermediate CA
kubectl exec vault-0 -n vault -- vault secrets enable -path=pki_int pki

#set default ttl
kubectl exec vault-0 -n vault -- vault secrets tune -max-lease-ttl=43800h pki_int

#create intermediate CA with common name example.com and 
#save the CSR (Certificate Signing Request) in a seperate file
kubectl exec vault-0 -n vault -- vault write -format=json pki_int/intermediate/generate/internal \
        common_name="roava.app Intermediate Authority" \
        | jq -r '.data.csr' > pki_intermediate.csr

#send the intermediate CA's CSR to the root CA for signing
#save the generated certificate in a sepearate file         
kubectl exec vault-0 -n vault -- vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
        format=pem_bundle ttl="43800h" \
        | jq -r '.data.certificate' > intermediate.cert.pem


#publish the signed certificate back to the Intermediate CA
kubectl exec vault-0 -n vault -- vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

#publish the intermediate CA urls
kubectl exec vault-0 -n vault -- vault write pki_int/config/urls \
     issuing_certificates="https://34.121.62.102:8200/v1/pki_int/ca" \
     crl_distribution_points="https://34.121.62.102:8200/v1/pki_int/crl"

#vault secrets disable pki_int