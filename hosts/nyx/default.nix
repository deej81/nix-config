#############################################################
#
#  Nyx
#
###############################################################

{ inputs, configLib, ... }: {
  imports = [
    #################### Hardware Modules ####################
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd

    #################### Required Configs ####################
    ../../disks/ext4-luks.nix
    ./hardware-configuration.nix
    (configLib.relativeToRoot "hosts/common/core")

    #################### Host-specific Optional Configs ####################
    (configLib.relativeToRoot "hosts/common/optional/services/openssh.nix")

    # Desktop
    (configLib.relativeToRoot "hosts/common/optional/services/greetd.nix") # display manager
    (configLib.relativeToRoot "hosts/common/optional/hyprland.nix") # window manager
    (configLib.relativeToRoot "hosts/common/optional/pipewire.nix")
    (configLib.relativeToRoot "hosts/common/optional/spotify.nix")

    (configLib.relativeToRoot "hosts/common/optional/_1password.nix")
    (configLib.relativeToRoot "hosts/common/optional/google-chrome.nix")
    (configLib.relativeToRoot "hosts/common/optional/aider.nix")
    (configLib.relativeToRoot "hosts/common/optional/claude-code.nix")
    (configLib.relativeToRoot "hosts/common/optional/steam.nix")
    (configLib.relativeToRoot "hosts/common/optional/tailscale.nix")
    (configLib.relativeToRoot "hosts/common/optional/docker.nix")
    (configLib.relativeToRoot "hosts/common/optional/distrobox.nix")
    (configLib.relativeToRoot "hosts/common/optional/quickemu.nix")
    (configLib.relativeToRoot "hosts/common/optional/services/localsend.nix")
    (configLib.relativeToRoot "hosts/common/optional/remmina.nix")
    (configLib.relativeToRoot "hosts/common/optional/programming/azuredatastudio.nix")
    (configLib.relativeToRoot "hosts/common/optional/vagrant.nix")
    (configLib.relativeToRoot "hosts/common/optional/packer.nix")
    (configLib.relativeToRoot "hosts/common/optional/ansible.nix")

    #################### Users to Create ####################
    (configLib.relativeToRoot "hosts/common/users/deej")
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  networking = {
    hostName = "nyx";
    # networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot


  console.keyMap = "uk";

  # VirtualBox settings for Hyprland to display correctly
  # environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  # environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # Fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
