{ inputs, lib }:
{
  username = "deej";
  domain = inputs.nix-secrets.domain;
  #userFullName = inputs.nix-secrets.full-name;
  handle = "deej";
  #userEmail = inputs.nix-secrets.user-email;
  gitEmail = "nope";
  #workEmail = inputs.nix-secrets.work-email;
  networking = import ./networking.nix { inherit lib; };
}
