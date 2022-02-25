#!/usr/bin/sh

download_openshift_client()
{
  OKD_RELEASES_SITE_URL="https://github.com/openshift/okd/releases"
  INSTALLER_FULL_PATH=$(curl -s -k $OKD_RELEASES_SITE_URL | grep 'openshift-client-linux-.*.tar.gz' | head -n +1 | sed 's/\(.*<a href="\/\)\(.*\)\(" rel="nofollow">\)/\2/')
  INSTALLER_FILE=${INSTALLER_FULL_PATH##*/}
  INSTALLER_VERSION=$(echo $INSTALLER_FILE | sed 's/\(^openshift-client-linux-\)\(.*\)\(\.tar.gz$\)/\2/')
  
  pushd . ; cd /tmp
  wget --no-check-certificate "https://github.com/${INSTALLER_FULL_PATH}" -O "${INSTALLER_FILE}"
  tar tzvf "${INSTALLER_FILE}"
  tar zxvf "${INSTALLER_FILE}" oc kubectl
  popd

  pushd . ; cd /usr/local/bin
  rm -f oc 
  mv /tmp/oc oc-$INSTALLER_VERSION
  ln -s oc-$INSTALLER_VERSION oc
  rm -f kubectl
  mv /tmp/kubectl kubectl-$INSTALLER_VERSION
  ln -s kubectl-$INSTALLER_VERSION kubectl
  popd

  echo ""
  echo "oc version:"
  echo ""
  oc version || true
  echo ""
  echo "kubectl version:"
  echo ""
  kubectl version || true
  echo ""
}

download_openshift_installer()
{
  OKD_RELEASES_SITE_URL="https://github.com/openshift/okd/releases"
  INSTALLER_FULL_PATH=$(curl -s -k $OKD_RELEASES_SITE_URL | grep 'openshift-install-linux-.*.tar.gz' | head -n +1 | sed 's/\(.*<a href="\/\)\(.*\)\(" rel="nofollow">\)/\2/')
  INSTALLER_FILE=${INSTALLER_FULL_PATH##*/}
  INSTALLER_VERSION=$(echo $INSTALLER_FILE | sed 's/\(^openshift-install-linux-\)\(.*\)\(\.tar.gz$\)/\2/')
  
  pushd . ; cd /tmp
  wget --no-check-certificate "https://github.com/${INSTALLER_FULL_PATH}" -O "${INSTALLER_FILE}"
  tar tzvf "${INSTALLER_FILE}"
  tar zxvf "${INSTALLER_FILE}" openshift-install
  popd

  pushd . ; cd /usr/local/bin
  rm openshift-install
  mv /tmp/openshift-install openshift-install-$INSTALLER_VERSION
  ln -s openshift-install-$INSTALLER_VERSION openshift-install  
  popd

  echo ""
  echo "openshift-install version:"
  echo ""
  openshift-install version
  echo ""
}


set -e

download_openshift_installer
download_openshift_client

tree /usr/local/bin

openshift-install version
