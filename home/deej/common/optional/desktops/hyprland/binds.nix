{ lib, config, ... }: {
  wayland.windowManager.hyprland.settings = {

    "$mainMod" = "SUPER";

    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];

    bind =
      let
        workspaces = [
          "0"
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
          "F1"
          "F2"
          "F3"
          "F4"
          "F5"
          "F6"
          "F7"
          "F8"
          "F9"
          "F10"
          "F11"
          "F12"
        ];
        # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
        directions = rec {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
          h = left;
          l = right;
          k = up;
          j = down;
        };

        #swaylock = "${config.programs.swaylock.package}/bin/swaylock";
        #playerctl = "${config.services.playerctld.package}/bin/playerctl";
        #playerctld = "${config.services.playerctld.package}/bin/playerctld";
        #makoctl = "${config.services.mako.package}/bin/makoctl";
        #wofi = "${config.programs.wofi.package}/bin/wofi";
        #pass-wofi = "${pkgs.pass-wofi.override {
        #pass = config.programs.password-store.package;
        #}}/bin/pass-wofi";

        #grimblast = "${pkgs.inputs.hyprwm-contrib.grimblast}/bin/grimblast";
        #pactl = "${pkgs.pulseaudio}/bin/pactl";
        #tly = "${pkgs.tly}/bin/tly";
        #gtk-play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
        #notify-send = "${pkgs.libnotify}/bin/notify-send";

        #gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
        #xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
        #defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

        #terminal = config.home.sessionVariables.TERM;
        #browser = defaultApp "x-scheme-handler/https";
        #editor = defaultApp "text/plain";
      in
      [
        
        #################### Basic Bindings ####################
        "$mainMod, T, exec, kitty"  # open the terminal
        "$mainMod, B, exec, firefox" # open browser
        "$mainMod, Q, killactive," # close the active window
        "$mainMod, L, exec, swaylock" # Lock the screen
        "$mainMod, M, exec, wlogout --protocol layer-shell" # show the logout window
        "$mainMod SHIFT, M, exit," # Exit Hyprland all together no (force quit Hyprland)
        "$mainMod, E, exec, thunar" # Show the graphical file browser
        "$mainMod, V, togglefloating," # Allow a window to float
        "$mainMod, SPACE, exec, wofi" # Show the graphical app launcher
        "$mainMod, P, pseudo" # dwindle
        "$mainMod, J, togglesplit," # dwindle
        "$mainMod, S, exec, grim -g \"$(slurp)\" - | swappy -f - " # take a screenshot
        "$mainMod, F, fullscreen,"
      ] ++
      # Change workspace
      (map
        (n:
          "ALT,${n},workspace,name:${n}"
        )
        workspaces) ++
      # Move window to workspace
      (map
        (n:
          "SHIFTALT,${n},movetoworkspacesilent,name:${n}"
        )
        workspaces) ++
      # Move focus
      (lib.mapAttrsToList
        (key: direction:
          "ALT,${key},movefocus,${direction}"
        )
        directions) ++
      # Swap windows
      (lib.mapAttrsToList
        (key: direction:
          "SUPERSHIFT,${key},swapwindow,${direction}"
        )
        directions) ++
      # Move windows
      (lib.mapAttrsToList
        (key: direction:
          "SHIFTALT,${key},movewindoworgroup,${direction}"
        )
        directions) ++
      # Move monitor focus
      (lib.mapAttrsToList
        (key: direction:
          "SUPERALT,${key},focusmonitor,${direction}"
        )
        directions) ++
      # Move workspace to other monitor
      (lib.mapAttrsToList
        (key: direction:
          "SUPERALTSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
        )
        directions);
  };
}
