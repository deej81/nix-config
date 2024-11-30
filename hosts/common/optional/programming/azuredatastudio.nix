{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.unstable.azuredatastudio
  ];
}
