{ pkgs, inputs, config, lib, configVars, configLib, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive (configLib.relativeToRoot "keys/");
in
{

  users.users.${configVars.username} = {
    name = configVars.username;
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ] ++ ifTheyExist [
      "audio"
      "video"
      "docker"
      "git"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd3A1YkY2EjkOU9/mxOECBGkvUq09QzIAZO7hEhqJ6U"
    ];
    hashedPasswordFile = config.sops.secrets.initial_password.path;
    shell = pkgs.zsh; # default shell

    packages = [ pkgs.home-manager ];
  };

  # Import this user's personal/home configurations
  home-manager.users.${configVars.username} = import (configLib.relativeToRoot "home/${configVars.username}/${config.networking.hostName}.nix");

}
