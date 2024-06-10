#!/usr/bin/env bash

# TO RUN ON A LOCAL VM IN MINIMAL INSTALLER (set passwd first)
# ssh -p22220 nixos@localhost -o PreferredAuthentications=password 'bash -s' < bootstrap-vm.sh


# basic efi partiion of VM HD using parted script
DISK="/dev/vda"  # Replace with your actual disk identifier

sudo parted --script $DISK \
    mklabel gpt \
    mkpart primary fat32 1MiB 551MiB \
    set 1 esp on \
    mkpart primary linux-swap 551MiB 4.5GiB \
    mkpart primary ext4 4.5GiB 100% \
    print

sudo mkfs.ext4 -L NIXOS_ROOT $DISK"3"
sudo mkswap -L NIXOS_SWAP $DISK"2"
sudo mkfs.fat -F 32 -n BOOT $DISK"1"

# Mount the partitions
sudo mount /dev/disk/by-label/NIXOS_ROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot
sudo swapon /dev/disk/by-label/NIXOS_SWAP


