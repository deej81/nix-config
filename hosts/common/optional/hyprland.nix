{ pkgs, ... }:
{

  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland; # default
  };

  services.blueman.enable = true;

  environment.systemPackages = [
    pkgs.swaynotificationcenter
    pkgs.swww
  ];

}
