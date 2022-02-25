#!/usr/bin/sh

ansible -i proxmox2.lan, all -m shell -a 'for vmid in 200 201 202 203; do qm stop $vmid; done'
ansible -i proxmox.lan, all -m shell -a 'for vmid in 204 205; do qm stop $vmid; done'

terraform destroy -auto-approve
terraform init
terraform validate
terraform plan -out okd
terraform apply okd
