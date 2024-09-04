{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/helper-scripts
    common/optional/desktops
    common/optional/dev
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
    "eDP-1,2256x1504@144,0x0,1"
  ];
}
