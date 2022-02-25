#!/usr/bin/sh

ansible -i proxmox2.lan, all -m shell -a 'for vmid in 200 201 202 203; do qm stop $vmid; qm destroy $vmid; done'
ansible -i proxmox.lan, all -m shell -a 'for vmid in 204 205; do qm stop $vmid; qm destroy $vmid; done'
rm -f terraform.tfstate*
rm -f .terraform.lock.hcl
rm -f okd

