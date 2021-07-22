#!/bin/bash

set -eu



# my.vmware.com CLI install (https://github.com/apnex/vmw-cli)

docker run apnex/vmw-cli shell > vmw-cli
chmod 755 vmw-cli
# added sudo
sudo mv vmw-cli /usr/bin/



# download tanzu bits

vmw-cli ls vmware_tanzu_kubernetes_grid
vmw-cli cp tanzu-cli-bundle-v1.3.1-linux-amd64.tar
vmw-cli cp kubectl-linux-v1.20.5-vmware.1.gz



# install tanzu cli

tar -xvf tanzu-cli-bundle-v1.3.1-linux-amd64.tar

sudo install cli/core/v1.3.1/tanzu-core-linux_amd64 /usr/local/bin/tanzu

tanzu plugin clean
tanzu plugin install --local cli all
tanzu plugin list



# install kubectl

gzip -d kubectl-linux-v1.20.5-vmware.1.gz
chmod 755 kubectl-linux-v1.20.5-vmware.1
sudo mv kubectl-linux-v1.20.5-vmware.1 /usr/local/bin/kubectl



# cleanup

rm -f tanzu-cli-bundle-v1.3.1-linux-amd64.tar
rm -rf cli
