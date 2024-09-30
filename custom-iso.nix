{ pkgs, modulesPath, lib, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    fastfetch
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd3A1YkY2EjkOU9/mxOECBGkvUq09QzIAZO7hEhqJ6U"
  ];

  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd3A1YkY2EjkOU9/mxOECBGkvUq09QzIAZO7hEhqJ6U"
  ];

  isoImage.isoName = lib.mkForce "deej-nixos-installer.iso";

}
