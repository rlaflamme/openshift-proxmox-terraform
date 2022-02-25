#!/usr/bin/sh

update_okd_auth_dir()
{
  REMOTE_OKD_AUTH_DIR="okd4-cli.lab:/root/openshift-proxmox-terraform/install_dir/auth"
  LOCAL_OKD_AUTH_DIR="/root/install_dir
  
  pushd . ; cd $LOCAL_OKD_AUTH_DIR
  rm -rf auth
  scp -rp $REMOTE_OKD_AUTH_DIR .
  popd

}

update_okd_auth_dir
