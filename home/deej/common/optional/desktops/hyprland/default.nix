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
    ../waybar.nix
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
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        "col.active_border" = "rgba(595959aa)";
        "col.inactive_border" = "rgba(22222200)";
        layout = "dwindle";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 8;
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 10;
          passes = 4;
          ignore_opacity = true;
          new_optimizations = true;
          xray = true;
          blurls = [
            "lockscreen"
            "wofi"
            "swaync-control-center"
            "waybar"
          ];
          popups = true;
        };

      };

      layerrule = [
        "ignorezero, swaync-control-center"
        "ignorezero, waybar"
      ];

      windowrulev2 = [
        "workspace 10,class:(Slack)"
        "workspace 9,class:(Spotify)"
      ];

      input = {
        kb_layout = "gb";
        follow_mouse = 1;
      };
    };
  };

  services.blueman-applet.enable = true;

  programs.wofi.enable = true;
  programs.wofi.settings = {
    "width" = 900;
    "height" = 350;
    "location" = "center";
    "show" = "drun";
    "prompt" = "Search...";
    "filter_rate" = 100;
    "allow_markup" = true;
    "no_actions" = true;
    "halign" = "fill";
    "orientation" = "vertical";
    "content_halign" = "fill";
    "insensitive" = true;
    "allow_images" = true;
    "image_size" = 40;
    "columns" = 2;
  };
  programs.wofi.style = ''
    @define-color background rgba(30,30,46,0.8);
    @define-color foreground rgb(220, 220, 220);
    @define-color outline rgba(255, 255, 255, 0.15);
    @define-color accent rgb(226, 204, 219);
    @define-color textbox rgba(255, 255, 255, 0.05);
    @define-color highlight rgba(255, 255, 255, 0.1);

    * {
        all:unset;
    }

    window {
        background: rgba(200,200,200,0.05);
        border-radius: 10px;
        border: 1px solid @outline;
        font-family: Inter Nerd Font;
        font-weight: 200;
    }

    #outer-box {
        padding: 2em;
    }

    #input {
        padding:1em .75em;
        margin: 0em .25em;
        font-size:1.5em;
        background: rgba(200,200,200,0.05);
        border: 1px solid transparent;
        box-shadow: inset 0 -.15rem @accent;
        transition: background-color .30s ease-in-out;
    }

    #input image {
        margin-right:-1em;
        color:transparent;
    }

    #input:focus {
        background:@highlight;
        border: 1px solid @outline;
    }

    #scroll {
        margin-top: 1.5em;
    }

    #entry {
        border: 1px solid transparent;
        padding:1em;
        margin: .25rem;
        font-weight: normal;
        box-shadow: inset 0rem 0px rgba(0, 0, 0, 0);
        transition: box-shadow .30s ease-in-out, background-color .30s ease-in-out;
    }

    #entry image {
        margin-right: .75em;
    }

    #entry:selected {
        background-color: @highlight;
        border: 1px solid @outline;
        box-shadow: inset .2rem 0px @accent;

    }
  '';

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
