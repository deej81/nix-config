{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/helper-scripts
    common/optional/desktops
    common/optional/dev
    common/optional/dev/rider.nix
    common/optional/browsers/firefox.nix
    common/optional/comms/slack.nix
    common/optional/comms/signal.nix
    common/optional/tools/_1password-ssh.nix
    common/optional/sops.nix


  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-2,2560x1440@60,0x500,1"
    "HDMI-A-2,3840x2160@60,2560x0,1"
    "HDMI-A-1,2560x1440@60,6400x500,1"
  ];
}
