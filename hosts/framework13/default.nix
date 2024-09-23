#############################################################
#
#  Framework13
#
###############################################################

{ inputs, configLib, pkgs, ... }: {
  imports = [
    #################### Hardware Modules ####################
    inputs.hardware.nixosModules.framework-12th-gen-intel

    #################### Required Configs ####################
    ./imported/hardware-configuration.nix
    (configLib.relativeToRoot "hosts/common/core")

    #################### Host-specific Optional Configs ####################
    (configLib.relativeToRoot "hosts/common/optional/services/openssh.nix")

    # Desktop
    (configLib.relativeToRoot "hosts/common/optional/services/greetd.nix") # display manager
    (configLib.relativeToRoot "hosts/common/optional/hyprland.nix") # window manager
    (configLib.relativeToRoot "hosts/common/optional/pipewire.nix")
    (configLib.relativeToRoot "hosts/common/optional/spotify.nix")

    (configLib.relativeToRoot "hosts/common/optional/_1password.nix")
    (configLib.relativeToRoot "hosts/common/optional/tailscale.nix")
    (configLib.relativeToRoot "hosts/common/optional/docker.nix")
    (configLib.relativeToRoot "hosts/common/optional/distrobox.nix")
    (configLib.relativeToRoot "hosts/common/optional/quickemu.nix")
    (configLib.relativeToRoot "hosts/common/optional/programming/cursor.nix")
    (configLib.relativeToRoot "hosts/common/optional/services/localsend.nix")


    #################### Users to Create ####################
    (configLib.relativeToRoot "hosts/common/users/deej")
  ];

  services.gnome.gnome-keyring.enable = true;
  # TODO enable and move to greetd area? may need authentication dir or something?
  # services.pam.services.greetd.enableGnomeKeyring = true;

  networking = {
    hostName = "framework13";
    # networkmanager.enable = true;
    enableIPv6 = false;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-7676780f-3a70-4fa8-9f6a-18803365399f".device = "/dev/disk/by-uuid/7676780f-3a70-4fa8-9f6a-18803365399f";

  # fingerprint reader
  environment.systemPackages = [
    pkgs.fprintd
    pkgs.brightnessctl
  ];
  services.fprintd.enable = true;

  #framework firmware updates
  services.fwupd.enable = true;

  # VirtualBox settings for Hyprland to display correctly
  # environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  # environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # Fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
