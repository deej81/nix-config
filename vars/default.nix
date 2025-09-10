{ inputs, lib, hostName ? null }:
let
  # Default configuration
  defaultConfig = {
    username = "deej";
    domain = inputs.nix-secrets.domain or "example.com";
    #userFullName = inputs.nix-secrets.full-name or "User";
    handle = "deej";
    #userEmail = inputs.nix-secrets.user-email or "user@example.com";
    gitEmail = "nope";
    #workEmail = inputs.nix-secrets.work-email or "work@example.com";
    networking = import ./networking.nix { inherit lib; };
    
    # Font sizes - can be overridden per host
    fontSizes = {
      terminal = 15;
      editor = 16;
      waybar = 16;
    };
  };

  # Load host-specific overrides if they exist
  hostOverrides = 
    if hostName != null && builtins.pathExists (./hosts + "/${hostName}.nix")
    then import (./hosts + "/${hostName}.nix")
    else {};
    
    
  # Recursively merge configurations
  mergeConfig = base: override: 
    if builtins.isAttrs base && builtins.isAttrs override
    then lib.recursiveUpdate base override
    else override;
in
mergeConfig defaultConfig hostOverrides
