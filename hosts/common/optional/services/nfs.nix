{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nfs-utils
  ];

  services.nfs.server.enable = true;
}
