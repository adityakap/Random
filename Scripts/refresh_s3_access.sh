git_pat=$1
lease_duration=${2:-10h}

client_token=$(curl -s -X POST "http://<VAULT_ADDR>/v1/auth/github/login" -H 'Content-Type: application/json' -d '{"token": "'"$git_pat"'"}' | jq -r .auth.client_token)

# bucket1_keys Fetch & Configuration
bucket1_keys=$(curl -s -X GET "http://<VAULT_ADDR>/v1/aws_storage/sts/<github_team>?ttl=${lease_duration}" -H "X-Vault-Token: ${client_token}")


ak_ib=$( echo "$bucket1_keys" | jq -r '.data.access_key')
echo ${ak_ib}
sk_ib=$(echo "$bucket1_keys" | jq -r '.data.secret_key')
echo ${sk_ib}
st_ib=$( echo "$bucket1_keys" | jq -r '.data.security_token')

echo "Updating p1 profile on ~/.aws/credentials with new credentials"
aws configure set aws_access_key_id ${ak_ib} --profile p1
aws configure set aws_secret_access_key ${sk_ib} --profile p1
aws configure set aws_session_token ${st_ib} --profile p1

sleep 1

# bucket2_keys fetch & configuration
bucket2_keys=$(curl -s -X GET "http://<VAULT_ADDR>/v1/aws_storage/sts/<github_team>?ttl=${lease_duration}" -H "X-Vault-Token: ${client_token}")

ak_db=$( echo "$bucket2_keys" | jq -r '.data.access_key')
echo ${ak_db}
sk_db=$(echo "$bucket2_keys" | jq -r '.data.secret_key')
echo ${sk_db}
st_db=$( echo "$bucket2_keys" | jq -r '.data.security_token')

echo "Updating p2 profile on ~/.aws/credentials with new credentials"
aws configure set aws_access_key_id ${ak_db} --profile p2
aws configure set aws_secret_access_key ${sk_db} --profile p2
aws configure set aws_session_token ${st_db} --profile p2

sleep 1

# bucket3_keys fetch & configuration
processing_bucket_keys=$(curl -s -X GET "http://<VAULT_ADDR>/v1/aws_storage/sts/<github_team>?ttl=${lease_duration}" -H "X-Vault-Token: ${client_token}")

ak_pb=$( echo "$bucket3_keys" | jq -r '.data.access_key')
echo ${ak_pb}
sk_pb=$(echo "$bucket3_keys" | jq -r '.data.secret_key')
echo ${sk_pb}
st_pb=$( echo "$bucket3_keys" | jq -r '.data.security_token')

echo "Updating p3 profile on ~/.aws/credentials with new credentials"
aws configure set aws_access_key_id ${ak_pb} --profile p3
aws configure set aws_secret_access_key ${sk_pb} --profile p3
aws configure set aws_session_token ${st_pb} --profile p3