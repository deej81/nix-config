{ pkgs, inputs, config, lib, configVars, configLib, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive (configLib.relativeToRoot "keys/");
in
{
  # Decrypt ta-password to /run/secrets-for-users/ so it can be used to create the user
  # users.mutableUsers = false; # Required for password to be set via sops during system activation!

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
    # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
    #openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

    shell = pkgs.zsh; # default shell

    packages = [ pkgs.home-manager ];
  };

  # Import this user's personal/home configurations
  home-manager.users.${configVars.username} = import (configLib.relativeToRoot "home/${configVars.username}/${config.networking.hostName}.nix");

}
