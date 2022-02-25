#!/usr/bin/sh

update_okd_auth_dir()
{
  SOURCE_OKD_AUTH_DIR="/root/openshift-proxmox-terraform/install_dir/auth"
  DEST_OKD_AUTH_DIR="/root/install_dir"
  
  pushd . ; cd $DEST_OKD_AUTH_DIR
  rm -rf auth
  cp -rp $SOURCE_OKD_AUTH_DIR .
  popd

}

update_okd_auth_dir
