#!/usr/bin/sh

okd_wait_for_bootstrap_complete()
{
  openshift-install --dir=install_dir/ wait-for bootstrap-complete --log-level=info
}

okd_wait_for_bootstrap_complete

# Login to the cluster and approve CSRs
