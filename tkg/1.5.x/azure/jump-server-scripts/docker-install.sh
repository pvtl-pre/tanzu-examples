#!/bin/bash

set -eux -o pipefail



# docker install (https://docs.docker.com/engine/install/ubuntu/)

sudo apt-get update

# added --assume-yes
sudo apt-get --assume-yes install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# added --yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
# added --assume-yes
sudo apt-get --assume-yes install docker-ce docker-ce-cli containerd.io



# docker non-privilege mode (https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

# -f added in case it exists
sudo groupadd docker -f
sudo usermod -aG docker $USER
