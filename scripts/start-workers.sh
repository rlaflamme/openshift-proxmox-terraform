#!/usr/bin/sh

ansible -i proxmox.lan, all -m shell -a 'for vmid in 204 205; do qm start $vmid; done'

