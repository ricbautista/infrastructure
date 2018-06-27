#!/bin/bash

latest=$(echo "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip")
latest_filename=$(basename $latest)

cd /tmp
rm -f $latest_filename || :
wget $latest
rm -f terraform || :
unzip $latest_filename
sudo mv -f terraform /usr/local/bin

