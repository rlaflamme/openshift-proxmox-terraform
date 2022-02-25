#!/usr/bin/sh
terraform init
terraform validate
terraform plan -out okd
terraform apply okd
