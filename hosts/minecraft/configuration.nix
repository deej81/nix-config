{ config, pkgs, ... }:

let
  disko-config = import ./disko-config.nix { inherit (config.nixpkgs) pkgs; };
in
{
  imports = [
    disko-config
    "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable =true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "minecraft-server";
  networking.firewall.allowedTCPPorts = [ 22 25565 ];

  # Enable OpenSSH daemon
  services.openssh.enable = true;

  # Minecraft server service
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    package = pkgs.minecraft-server;
    declarative = true;
    serverProperties = {
      server-port = 25565;
      difficulty = 1;
      gamemode = "survival";
      max-players = 20;
      motd = "Welcome to NixOS Minecraft Server!";
      white-list = false;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # User account
  users.users.minecraft = {
    isSystemUser = true;
  };

  users.users.deej = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # make the tailscale command usable to users
  environment.systemPackages = [ pkgs.tailscale ];

  # enable the tailscale service
  services.tailscale.enable = true;

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "23.11"; # Change this to your NixOS version
}
