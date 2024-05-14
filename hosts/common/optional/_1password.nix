{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.unstable._1password-gui
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "deej" ];
  };
}
