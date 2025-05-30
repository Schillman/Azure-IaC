#!/bin/bash
function update_kv_secret {
	base64 -i tf_secrets-min.json -o tf_secrets_base64.txt
	echo 'file converted to base64'
	az keyvault secret set --name tf-secrets-base64 --vault-name $1 --file tf_secrets_base64.txt --encoding base64
}

update_kv_secret kv-schillman-management
