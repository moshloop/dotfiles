
acm_import_pfx() {
  CERT=$1
  read -sp 'Password: ' PW
  openssl pkcs12 -in $1 -out $1.pem -clcerts -passin pass:$PW -nodes
  openssl pkcs12 -in $1 -out $1.root.pem -cacerts -passin pass:$PW -nodes -nokeys
  openssl rsa -in $1.pem -out $1.key -passin pass:$PW -passout pass:""
  openssl pkcs12 -in $1 -out $1.pem -clcerts -passin pass:$PW -nodes -nokeys

  aws acm import-certificate --region $AWS_REGION --certificate file://$PWD/$1.pem \
                              --certificate-chain file://$PWD/$1.root.pem \
                              --private-key file://$PWD/$1.key
}

copy_ami() {
  export AWS_REGION=$(echo $1 | cut -d/ -f1)
  ami=$(echo $1 | cut -d/ -f2)
  # >&2 echo aws ec2 copy-image --region $2 --source-image-id $ami --source-region $AWS_REGION --name $(get_ami $ami | jq -r '.Name') | jq -r '.ImageId'
  ami=$(aws ec2 copy-image --region $2 --source-image-id $ami --source-region $AWS_REGION --name $(get_ami $ami | jq -r '.Name') | jq -r '.ImageId')
  export AWS_REGION=$2
  while [[ "$(get_ami $2/$ami | jq -r '.State')" != "available"  ]];
  do
    >&2 echo "... waiting for $ami to be available: $(get_ami $2/$ami | jq -r '.State') "
    sleep 5
  done
  >&2 echo "copy complete"
  echo $ami

}

share_ami() {
  image=$1
  if [[ "$image" = *"/"* ]]; then
    AWS_REGION=$(echo $image | cut -d/ -f1)
    image=$(echo $image | cut -d/ -f2)
  fi
# >&2 echo aws ec2 modify-image-attribute --image-id "$image" --region $AWS_REGION --launch-permission "{\"Add\":[{\"UserId\":\"$2\"}]}"
  aws ec2 modify-image-attribute --image-id "$image" --region $AWS_REGION --launch-permission "{\"Add\":[{\"UserId\":\"$2\"}]}"

}

list_ami() {
  aws ec2 describe-images --owners $(get_current_account_id) --region $AWS_REGION | jq -r '.Images[] | [.ImageId,.Name] | join(",")' | sort -k 1 -t, -r
}

get_ami() {
  image=$1
  if [[ "$image" = *"/"* ]]; then
    AWS_REGION=$(echo $image | cut -d/ -f1)
    image=$(echo $image | cut -d/ -f2)
  fi
  ami=$( aws ec2 describe-images --owners $(get_current_account_id) --region  $AWS_REGION --image-id $image )
  # >&2 echo aws ec2 describe-images --owners $(get_current_account_id) --region  $AWS_REGION --image-id $image
  if [[ "$?" != "0" || "$ami" == "" ]]; then
    echo "{\"State\":\"missing\"}"
  else
    echo $ami | jq '.Images[0]'
  fi
}

get_current_account_id() {
  aws sts get-caller-identity | jq -r '.Account'
}

aws_clear() {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SECURITY_TOKEN
  unset AWS_SESSION_TOKEN
}


aws_assume() {
  if which totp 2&>1 > /dev/null; then
    token=$(totp aws | tr '\n' ' ' | sed 's/ //')
  else
    echo "Enter Token: "
    read -r
    token=$REPLY
  fi

  echo "Token: ($token)"
  mfa=$(aws sts get-caller-identity | jq -r '.Arn' | sed 's/user/mfa/')
  echo "Mfa: $mfa"
  aws sts get-session-token --serial-number $mfa --token-code $token
  arn=$(aws sts get-caller-identity --profile $1)
  role=$(echo $arn | jq -r '.Arn' | cut -d: -f6 | cut -d'/' -f2)
  echo "Role: $role"
  account=$(echo $arn | jq -r '.Account')
  role="arn:aws:iam::"$account":role/"$role
  cmd=$(echo aws sts assume-role --role-arn $role --role-session-name boto)
  echo $cmd
  json=$(aws sts assume-role --role-arn $role  --role-session-name boto)
  aws_runas "$json"
}

get_current_account() {
   account=$(aws sts get-caller-identity | jq -r '.Account')
   if [[ "${accounts[$account]}" != "" ]]; then
    account=${accounts[$account]}
   fi
   print $account
}

aws_runas() {
  echo $1
  AKID=$(echo $1 | jq '.Credentials.AccessKeyId')
  if [[ "$AKID" == "" ]]; then
    echo "ERROR: Invalid credentials: $1"
  else
    eval "export AWS_ACCESS_KEY_ID=$(echo $1 | jq '.Credentials.AccessKeyId')"
    eval "export AWS_SECRET_ACCESS_KEY=$(echo $1 | jq '.Credentials.SecretAccessKey')"
    eval "export AWS_SESSION_TOKEN=$(echo $1 | jq '.Credentials.SessionToken')"
  fi
}

aws_mfa() {
  json=$(aws sts get-caller-identity --serial-number $AWS_MFA_ID --token-code $(totp aws))
  eval "export AWS_ACCESS_KEY_ID=$(echo $json | jq -r '.Credentials.AccessKeyId')"
  eval "export AWS_SECRET_ACCESS_KEY=$(echo $json | jq -r '.Credentials.SecretAccessKey')"
  eval "export AWS_SESSION_TOKEN=$(echo $json | jq -r '.Credentials.SessionToken')"
}

update_r53_alias() {
      cat > json << EOL
    {
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "$1",
          "Type": "A",
          "AliasTarget": {
            "HostedZoneId": "$4"
            "DNSName": "$2"
          }
        }
      }
    ]
  }
EOL

  cat json

  aws route53 change-resource-record-sets --hosted-zone-id $3  --change-batch file://$PWD/json
  rm json
}