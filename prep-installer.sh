#!/bin/bash

# curl https://raw.githubusercontent.com/deej81/nix-config/main/prep-installer.sh | bash -s deej81


# Run this script from the minimal installer ISO to setup SSH access
GITHUB_USER=$1

mkdir -p /home/nixos/.ssh
curl https://github.com/$GITHUB_USER.keys > /home/nixos/.ssh/authorized_keys

nix-env -iA nixos.rsync
nix-env -iA nixos.just
