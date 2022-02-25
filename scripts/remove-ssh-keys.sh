#!/usr/bin/sh

remove_ssh_key()
{
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1" 2> /dev/null
}

remove_ssh_keys()
{
  echo "Removing ssh known hosts..."

  remove_ssh_key "$(dig + short okd4-bootstrap)"
  remove_ssh_key "$(dig + short okd4-control-plane-1)"
  remove_ssh_key "$(dig + short okd4-control-plane-2)"
  remove_ssh_key "$(dig + short okd4-compute-1)"
  remove_ssh_key "$(dig + short okd4-compute-2)"

  remove_ssh_key "okd4-bootstrap"
  remove_ssh_key "okd4-control-plane-1"
  remove_ssh_key "okd4-control-plane-2"
  remove_ssh_key "okd4-control-plane-3"
  remove_ssh_key "okd4-compute-1"
  remove_ssh_key "okd4-compute-2"
}

remove_ssh_keys
