{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    protonup
    
    # minecraft launcher
    prismlauncher
  ];

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/deej/.steam/root/compatibilitytools.d";
  };
}
