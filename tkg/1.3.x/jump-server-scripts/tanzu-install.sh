#!/bin/bash

set -eux -o pipefail



read -p 'Tanzu CLI download link: ' tanzu_cli_url
read -p 'Kubectl download link: ' kubectl_cli_url



# download tanzu bits

curl $tanzu_cli_url -o tanzu-cli-bundle.tar
curl $kubectl_cli_url -o kubectl.gz



# install tanzu cli

tar -xvf tanzu-cli-bundle.tar

sudo install cli/core/v*/tanzu* /usr/local/bin/tanzu

tanzu plugin clean
tanzu plugin install --local cli all
tanzu plugin list

# autocomplete
tanzu completion bash > $HOME/.tanzu/completion.bash.inc
printf "\n# Tanzu shell completion\nsource '$HOME/.tanzu/completion.bash.inc'\n" >> $HOME/.bash_profile



# install kubectl

gzip -d kubectl.gz
chmod 755 kubectl
sudo mv kubectl /usr/local/bin/kubectl

# autocomplete
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

echo "alias k=kubectl" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc



# cleanup

rm -f tanzu-cli-bundle.tar
rm -rf cli


# helpful tip

set +x
RED='\033[0;31m'
NC='\033[0m'
printf "\n${RED}Don't forget to reload bash: . ~/.bashrc && . ~/.bash_profile${NC}\n"