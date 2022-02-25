#!/usr/bin/sh

ansible -i proxmox2.lan, all -m shell -a 'for vmid in 201 202 203; do qm start $vmid; sleep 30; done'
ansible -i proxmox.lan, all -m shell -a 'for vmid in 204 205; do qm start $vmid; sleep 30; done'

