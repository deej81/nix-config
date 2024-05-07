{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    
    common/optional/helper-scripts

    common/optional/desktops
    common/optional/dev

    common/optional/browsers/brave.nix
    common/optional/browsers/firefox.nix

    common/optional/comms/slack.nix


  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
}
