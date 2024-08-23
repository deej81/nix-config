{ lib, config, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {

    "$mainMod" = "SUPER";

    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];

    bind =
      let
        workspaces = [
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
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

      in
      [

        #################### Basic Bindings ####################
        "$mainMod, T, exec, kitty" # open the terminal
        "$mainMod, B, exec, firefox" # open browser
        "$mainMod, Q, killactive," # close the active window
        "$mainMod, L, exec, hyprlock" # Lock the screen
        "$mainMod, M, exec, wlogout --protocol layer-shell" # show the logout window
        "$mainMod SHIFT, M, exit," # Exit Hyprland all together no (force quit Hyprland)
        "$mainMod, E, exec, thunar" # Show the graphical file browser
        "$mainMod, V, togglefloating," # Allow a window to float
        "$mainMod, SPACE, exec, wofi" # Show the graphical app launcher
        "$mainMod, P, pseudo" # dwindle
        "$mainMod, J, togglesplit," # dwindle
        "$mainMod, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f - " # take a screenshot
        "$mainMod, F, fullscreen,"
        ",XF86AudioRaiseVolume, exec, pamixer -i 2"
        ",XF86AudioLowerVolume, exec, pamixer -d 2"
        "SUPER,0,workspace,name:10"
        "SUPERSHIFT,0,movetoworkspace,name:10"
      ] ++
      # Change workspace
      (map
        (n:
          "SUPER,${n},workspace,name:${n}"
        )
        workspaces) ++
      # Move window to workspace
      (map
        (n:
          "SUPERSHIFT,${n},movetoworkspace,name:${n}"
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
