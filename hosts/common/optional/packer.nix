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

  # Configure libvirt
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
}