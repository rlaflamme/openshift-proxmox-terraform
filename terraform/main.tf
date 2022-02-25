terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.6"
    }
  }
}

provider "proxmox" {
  # url is the hostname (FQDN if you have one) for the proxmox host you'd like to connect to to issue the commands. my proxmox host is 'prox-1u'. Add /api2/json at the end for the API
  pm_api_url = "https://192.168.1.199:8006/api2/json"

  pm_api_token_id     = "terraform-prov@pam!mytoken"
  pm_api_token_secret = "07d68ad2-6e0a-4c03-901d-bb5649416692"

  #pm_api_token_id = "root@pam!root_token_id"
  #pm_api_token_secret = "93ac0482-fd7e-4860-be6a-59248918866c"


  # leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)
  pm_tls_insecure = true

  # Logging
  pm_debug      = true
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_log_levels = {
    _std    = "debug"
    _capturelog = ""
  }
  pm_timeout = 500
}

resource "proxmox_vm_qemu" "okd4-bootstrap" {
  vmid        = 200
  name        = "okd4-bootstrap"
  desc        = "Openshift bootstrap"
  memory      = 8192
  sockets     = 1
  cores       = 4
  cpu         = "kvm64"
  target_node = "pve2"
  iso         = var.fedora_core_iso_bootstrap
  onboot      = false
  oncreate    = false
  agent       = 0
  pool        = "okd-49"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  tablet      = false
  boot        = "order=scsi0;ide2;net0"

  vga {
    type = "std"
  }

  disk {
    type     = "scsi"
    storage  = "local-zfs"
    size     = "120G"
  }

  network {
    model   = "virtio"
    bridge  = "okdvnet1"
    macaddr = "6a:7b:d0:7f:5f:e0"
    queues  = 2
    mtu     = 1450
  }
}

resource "proxmox_vm_qemu" "okd4-control-plane-1" {
  vmid        = 201
  name        = "okd4-control-plane-1"
  desc        = "Openshift control plane 1"
  memory      = 16384
  sockets     = 1
  cores       = 4
  cpu         = "kvm64"
  target_node = "pve2"
  iso         = var.fedora_core_iso_master
  onboot      = false
  oncreate    = false
  agent       = 0
  pool        = "okd-49"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  tablet      = false
  boot        = "order=scsi0;ide2;net0"

  vga {
    type = "std"
  }

  disk {
    type     = "scsi"
    storage  = "local-zfs"
    size     = "120G"
  }

  network {
    model   = "virtio"
    bridge  = "okdvnet1"
    macaddr = "76:c4:8d:d2:1c:4b"
    queues  = 2
    mtu     = 1450
  }
}

resource "proxmox_vm_qemu" "okd4-control-plane-2" {
  vmid        = 202
  name        = "okd4-control-plane-2"
  desc        = "Openshift control plane 2"
  memory      = 16384
  sockets     = 1
  cores       = 4
  cpu         = "kvm64"
  target_node = "pve2"
  iso         = var.fedora_core_iso_master
  onboot      = false
  oncreate    = false
  agent       = 0
  pool        = "okd-49"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  tablet      = false
  boot        = "order=scsi0;ide2;net0"

  vga {
    type = "std"
  }

  disk {
    type     = "scsi"
    storage  = "local-zfs"
    size     = "120G"
  }

  network {
    model   = "virtio"
    bridge  = "okdvnet1"
    macaddr = "22:2f:f7:24:d5:f6"
    queues  = 2
    mtu     = 1450
  }
}

resource "proxmox_vm_qemu" "okd4-control-plane-3" {
  vmid        = 203
  name        = "okd4-control-plane-3"
  desc        = "Openshift control plane 3"
  memory      = 16384
  sockets     = 1
  cores       = 4
  cpu         = "kvm64"
  target_node = "pve2"
  iso         = var.fedora_core_iso_master
  onboot      = false
  oncreate    = false
  agent       = 0
  pool        = "okd-49"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  tablet      = false
  boot        = "order=scsi0;ide2;net0"

  vga {
    type = "std"
  }

  disk {
    type     = "scsi"
    storage  = "local-zfs"
    size     = "120G"
  }

  network {
    model   = "virtio"
    bridge  = "okdvnet1"
    macaddr = "ce:c2:9d:a6:6d:f2"
    queues  = 2
    mtu     = 1450
  }
}

resource "proxmox_vm_qemu" "okd4-compute-1" {
  vmid        = 204
  name        = "okd4-compute-1"
  desc        = "Openshift compute 1"
  memory      = 20480
  sockets     = 1
  cores       = 4
  cpu         = "kvm64"
  target_node = "pve"
  iso         = var.fedora_core_iso_worker
  onboot      = false
  oncreate    = false
  agent       = 0
  pool        = "okd-49"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  tablet      = false
  boot        = "order=scsi0;ide2;net0"

  vga {
    type = "std"
  }

  disk {
    type     = "scsi"
    storage  = "local-zfs"
    size     = "120G"
  }

  network {
    model   = "virtio"
    bridge  = "okdvnet1"
    macaddr = "a2:ea:17:4c:80:11"
    queues  = 2
    mtu     = 1450
  }
}

resource "proxmox_vm_qemu" "okd4-compute-2" {
  vmid        = 205
  name        = "okd4-compute-2"
  desc        = "Openshift compute 2"
  memory      = 20480
  sockets     = 1
  cores       = 4
  cpu         = "kvm64"
  target_node = "pve"
  iso         = var.fedora_core_iso_worker
  onboot      = false
  oncreate    = false
  agent       = 0
  pool        = "okd-49"
  #qemu_os = "linux"
  numa   = false
  scsihw = "virtio-scsi-pci"
  boot   = "order=scsi0;ide2;net0"

  vga {
    type = "std"
  }

  disk {
    type     = "scsi"
    storage  = "local-zfs"
    size     = "120G"
  }

  network {
    model   = "virtio"
    bridge  = "okdvnet1"
    macaddr = "c2:5f:7e:9d:e9:b9"
    queues  = 2
    mtu     = 1450
  }
}

