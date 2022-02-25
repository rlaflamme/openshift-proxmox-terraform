variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyFNVGtcevAqFRTB+boHO3aqqOlunXRuc0MVIJumisc6y2H+XvyW2Pk0khp0QNck1uPKzXNB5SziZp/xCadgQQgWCP7sh0h1R5/aMYnQHZZd9It+dXDNrBXvFIjzB3h7mr9d4neyp2iEN5vS377LagdZ7hj0U211JozcyPssJ6ESOtftHNVcnLPwkOkKoyKcTWTTSrUPlTUqOM8EDQsGOqOy6IgmBzzcfJ9J8WeocVF2fzCqHKGcUmRE/bw170g8fAg4iV5qYOnsvFMLepxp087MgvDyHzQhK+ockv1X/oJiX9VVUKxpNoLrXZmd+g1ADWOtcV+4acIUr9qY5K0fPUgmeTP0WRmQggD3LXMSQ0hKsRZvhSijleFMhZ2w9q9u7EoGa6ODnY1bhhKW7rJ3dYCEpUi7/02ZLFI+m6dZf8Ouenn4MpHmR8B86wP9luciu7xexCEwE1T+0tLG6OmyK+WMl0jAynU+PFiaefEFPyWa5qQsT7V0EhIdiXGQPvTT8= root@okd4-cli"
}

variable "proxmox_host" {
  default = "129.168.1.199"
}

variable "template_name" {
  default = "okd-master1"
}
variable "fedora_core_iso_bootstrap" {
  default = "local:iso/fcos-bootstrap.iso"
}
variable "fedora_core_iso_master" {
  default = "local:iso/fcos-master.iso"
}
variable "fedora_core_iso_worker" {
  default = "local:iso/fcos-worker.iso"
}
