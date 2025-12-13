#
# SDDM display manager https://wiki.archlinux.org/title/SDDM
#

{ config, pkgs, lib, ... }:

let
  cfg = config.autoLogin;
in
{
  # Declare custom options for conditionally enabling auto login
  options.autoLogin = {
    enable = lib.mkEnableOption "Enable automatic login";

    username = lib.mkOption {
      type = lib.types.str;
      default = "guest";
      description = "User to automatically login";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      sddm-astronaut
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [ sddm-astronaut ];

      # Auto login configuration
      autoLogin = lib.mkIf cfg.enable {
        relogin = true;
        user = cfg.username;
      };
    };

    # Set default session to Hyprland
    services.displayManager.defaultSession = "hyprland";
  };
}
