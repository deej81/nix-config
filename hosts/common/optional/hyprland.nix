{ pkgs, ... }:
{

  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland; # default
  };

  services.blueman.enable = true;

  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.xfce.thunar-volman
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-media-tags-plugin
    ];
  };

  programs.nm-applet.enable = true;

  programs.file-roller.enable = true;

  environment.systemPackages = [
    pkgs.swaynotificationcenter
    pkgs.swww
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.hyprpicker
    pkgs.capitaine-cursors
  ];
}
