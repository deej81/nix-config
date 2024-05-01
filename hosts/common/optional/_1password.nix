{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.unstable._1password
    pkgs.unstable._1password-gui
  ];
}
