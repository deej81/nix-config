{ config, pkgs, lib, gtkThemeFromScheme, ... }:

{


  gtk = {
    enable = true;
    #font.name =  TODO see misterio https://github.com/Misterio77/nix-config/blob/f4368087b0fd0bf4a41bdbf8c0d7292309436bb0/home/misterio/features/desktop/common/gtk.nix   he has a custom config for managing fonts, colorsheme etc.

    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };

    iconTheme = {
      name = "elementary-Xfce-dark";
      package = pkgs.elementary-xfce-icon-theme;
    };

    #TODO add ascendancy cursor pack
    #cursortTheme.name = "";
    #cursortTheme.package = ;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
    
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Materia-dark";
    };
  };

  home.sessionVariables.GTK_THEME = "Materia-dark";
}
