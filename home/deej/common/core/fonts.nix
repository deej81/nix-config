{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    noto-fonts
    meslo-lgs-nf
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}