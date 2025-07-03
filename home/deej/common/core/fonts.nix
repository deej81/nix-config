{ pkgs, lib, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = builtins.attrValues {
    inherit (pkgs)

      noto-fonts
      meslo-lgs-nf
      ;

    # inherit (pkgs.nerd-fonts)

    #   jetbrains-mono
    #   fira-code
    #   ;
  };

  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}