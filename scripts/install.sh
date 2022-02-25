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

okd_wait_for_bootstrap_complete()
{
  openshift-install --dir=install_dir/ wait-for bootstrap-complete --log-level=info
}

coreos_installer()
{
  docker run --privileged --pull=always --rm --mount type=bind,source=$PWD,target=/data -w /data \
	        quay.io/coreos/coreos-installer:release "$@"
}

butane()
{
  docker run --privileged --pull=always --rm --mount type=bind,source=$PWD,target=/data -w /data \
	        quay.io/coreos/butane:release "$@"
}

download_iso()
{
#  coreos_installer download -s stable -p metal -f iso --directory "$1"
  
#  scp proxmox.lan:/var/lib/vz/template/iso/fedora-coreos-35.20211203.3.0-live.x86_64.iso $RELEASE_DIR/.
  pushd . ; cd $RELEASE_DIR
  rm -f *.iso
  wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20211031.3.0/x86_64/fedora-coreos-34.20211031.3.0-live.x86_64.iso
  popd
}


download_xz()
{
#  coreos_installer download -s stable -p metal -f raw.xz --directory "$1"
  pushd . ; cd "$1"
  rm -f fcos.raw.xz fcos.raw.xz.sig
  wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20211031.3.0/x86_64/fedora-coreos-34.20211031.3.0-metal.x86_64.raw.xz
  wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20211031.3.0/x86_64/fedora-coreos-34.20211031.3.0-metal.x86_64.raw.xz.sig

#  wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/35.20211203.3.0/x86_64/fedora-coreos-35.20211203.3.0-metal.x86_64.raw.xz
#  wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/35.20211203.3.0/x86_64/fedora-coreos-35.20211203.3.0-metal.x86_64.raw.xz.sig
  ln -s fedora-coreos-*-metal.x86_64.raw.xz fcos.raw.xz
  ln -s fedora-coreos-*-metal.x86_64.raw.xz.sig fcos.raw.xz.sig
  popd
}

set -e

if [[ ! -a install-config.yaml ]]; then
  echo "File install-config.yaml not found"
  exit 255
fi

remove_ssh_keys


set -x

INSTALL_DIR=install_dir
OKD4_DIR=/var/www/html/okd4
RELEASE_DIR=release
ISO_DEST_DIR=/var/lib/vz/template/iso

echo "Removing install,iso,release directories"
rm -rf $INSTALL_DIR $RELEASE_DIR

echo "Create install,iso,release directories"
mkdir -p $INSTALL_DIR $RELEASE_DIR $ISO_DEST_DIR

echo "Download iso file"
download_iso $RELEASE_DIR

echo "Create ignition files"
rm -f install-{bootstrap,master,worker}.ign
butane install-bootstrap.yaml -o install-bootstrap.ign
butane install-master.yaml -o install-master.ign
butane install-worker.yaml -o install-worker.ign

#echo "Change original iso file, add ignition file"
coreos_installer iso ignition embed -i install-bootstrap.ign $RELEASE_DIR/fedora-coreos-*-live.x86_64.iso -o $RELEASE_DIR/fcos-bootstrap.iso
coreos_installer iso ignition embed -i install-master.ign    $RELEASE_DIR/fedora-coreos-*-live.x86_64.iso -o $RELEASE_DIR/fcos-master.iso
coreos_installer iso ignition embed -i install-worker.ign    $RELEASE_DIR/fedora-coreos-*-live.x86_64.iso -o $RELEASE_DIR/fcos-worker.iso

echo "Download raw.xz"
download_xz $RELEASE_DIR 

sudo chown $USER $RELEASE_DIR/*

echo "Copying install config yaml..."
cp install-config.yaml $INSTALL_DIR 

echo "Creting manifests..."
openshift-install create manifests --dir=$INSTALL_DIR
sed -i 's/mastersSchedulable: true/mastersSchedulable: False/' $INSTALL_DIR/manifests/cluster-scheduler-02-config.yml

echo "Creating ignition files..."
openshift-install create ignition-configs --dir=$INSTALL_DIR

echo "Copying apache files"
sudo rm -rf $OKD4_DIR/*

echo "Publish iso to proxmox nodes"
scp $RELEASE_DIR/*.iso proxmox.lan:$ISO_DEST_DIR/.
scp $RELEASE_DIR/*.iso proxmox2.lan:$ISO_DEST_DIR/.

sudo cp $RELEASE_DIR/fcos.raw.xz     $OKD4_DIR
sudo cp $RELEASE_DIR/fcos.raw.xz.sig $OKD4_DIR

sudo cp -R $INSTALL_DIR/* $OKD4_DIR

sudo chown -R apache. $OKD4_DIR
sudo chmod -R 755 $OKD4_DIR

remove_ssh_keys

echo "Testing..."
curl localhost/okd4/metadata.json

echo ""

#okd_wait_for_bootstrap_complete

# Login to the cluster and approve CSRs
