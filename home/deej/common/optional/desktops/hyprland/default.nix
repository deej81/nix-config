{ pkgs, lib, ... }:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww query || ${pkgs.swww}/bin/swww init
    ${pkgs.swww}/bin/swww img ${./wallpaper.png} &
  '';
in
{
  imports = [
    ./binds.nix
    ./waybar/waybar.nix
    ./rofi/rofi.nix
  ];

  # NOTE: xdg portal package is currently set in /hosts/common/optional/hyprland.nix

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    # plugins = [];

    settings = {
      env = [
        # OZONE seems to be a new feature for electron apps, having this turned on breaks vscode
        # "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland"
        "CLUTTER_BACKEND, wayland"
        "QT_QPA_PLATFORM, wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
      ];

      exec-once = [
        "1password --silent"
        ''${startupScript}/bin/start''
        "spotify"
        "slack"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      general = {
        gaps_in = 4;
        gaps_out = "0,8,8,8";
        border_size = 1;
        "col.active_border" = "rgba(595959aa)";
        "col.inactive_border" = "rgba(22222200)";
        layout = "dwindle";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 8;
        inactive_opacity = 0.9;

        blur = {
          enabled = true;
          size = 4;
          passes = 4;
          ignore_opacity = true;
          new_optimizations = true;
          xray = true;
          blurls = [
            "lockscreen"
            "wofi"
            "swaync-control-center"
            "rofi"
          ];
        };

      };

      layerrule = [
        "ignorezero, swaync-control-center"
        "ignorezero, waybar"
        "blur,waybar"
      ];

      windowrulev2 = [
        "workspace 10,class:(Slack)"
        "workspace 9,class:(Spotify)"
        "float, class:(Rofi)"
      ];

      input = {
        kb_layout = "gb";
        follow_mouse = 1;
      };
    };
  };

  services.blueman-applet.enable = true;


  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          path = "${./wallpaper.png}";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      image = [
        {
          path = "${../../../../face.webp}";
          size = 150;
          border_size = 4;
          border_color = "rgb(0C96F9)";
          rounding = -1; # Negative means circle
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(CFE6F4)";
          inner_color = "rgb(657DC2)";
          outer_color = "rgb(0D0E15)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };


}
