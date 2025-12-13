{ pkgs, ... }: {
  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # Install Packer and required packages
  environment.systemPackages = with pkgs; [
    packer
    qemu
    libvirt
    virt-manager
    virt-viewer
    xorriso
  ];

  # Add user to libvirtd group
  users.users.deej.extraGroups = [ "libvirtd" ];

  # OVMF images are now available by default with QEMU in NixOS 25.05+
}