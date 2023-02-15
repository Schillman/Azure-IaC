#!/bin/bash
function update_kv_secret {
	base64 tf_secrets_mini.json >tf_secrets_base64.txt
	echo 'file converted to base64'
	az keyvault secret set --name tf-secret-base64 --vault-name $1 --file tf_secrets_base64.txt --encoding base64
}

update_kv_secret kv-schillman-management
