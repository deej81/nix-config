{ pkgs, ... }: {
  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # Install Vagrant and required packages
  environment.systemPackages = with pkgs; [
    vagrant
    qemu
    libvirt
    virt-manager
    virt-viewer
  ];

  # Add user to libvirtd group
  users.users.deej.extraGroups = [ "libvirtd" ];
}