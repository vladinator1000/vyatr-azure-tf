#!/bin/bash

# Install a Perforce server using these instructions:
# https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html#For3

DISTRO="$(lsb_release -cs)"

wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add -
echo "deb http://package.perforce.com/apt/ubuntu ${DISTRO} release" > /etc/apt/sources.list.d/perforce.list

sudo apt-get update
sudo apt-get install helix-p4d

sudo /opt/perforce/sbin/configure-helix-p4d.sh -n $1 p $2 -r $3 -u $4 -P $5