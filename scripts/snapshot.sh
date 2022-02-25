#!/bin/sh
ansible -i proxmox2.lan, all -m shell -a 'for vmid in 201 202 203 204 205; do qm snapshot $vmid OKD4_9_$(date "+%Y%m%d") --description "4_9_0_0_okd-2021-12-12-02584720210817"; done'

