{ pkgs, ... }:
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
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland,x11,*"
        "CLUTTER_BACKEND, wayland"
        "QT_QPA_PLATFORM, wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "QT_STYLE_OVERRIDE,kvantum"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "XCURSOR_THEME,capitaine-cursors"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,capitaine-cursors"
        "HYPRCURSOR_SIZE,24"
        # TODO: Remove this AMD GPU workaround when crashes are fixed
        # Workaround for CHyprOpenGLImpl::begin crashes on AMD GPUs
        # Note: explicit_sync config was removed in Hyprland 0.50+, this is the only option
        # See: https://github.com/hyprwm/Hyprland/issues/9746
        "AQ_NO_MODIFIERS,1"
      ];

      xwayland = {
        #force_zero_scaling = true;
      };

      exec-once = [
        "1password --silent"
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

      animations = {
        enabled = true;
        
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        
        animation = [
          "global,1,10,default"
          "border,1,5.39,easeOutQuint"
          "windows,1,4.79,easeOutQuint"
          "windowsIn,1,4.1,easeOutQuint,popin 87%"
          "windowsOut,1,1.49,linear,popin 87%"
          "fadeIn,1,1.73,almostLinear"
          "fadeOut,1,1.46,almostLinear"
          "fade,1,3.03,quick"
          "layers,1,3.81,easeOutQuint"
          "layersIn,1,4,easeOutQuint,fade"
          "layersOut,1,1.5,linear,fade"
          "fadeLayersIn,1,1.79,almostLinear"
          "fadeLayersOut,1,1.39,almostLinear"
          "workspaces,0,0,ease"
        ];
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
        "workspace 9,class:(spotify)"
        "float, class:(Rofi)"
      ];

      input = {
        kb_layout = "gb";
        follow_mouse = 1;
        numlock_by_default = true;
      };
    };
  };

  services.blueman-applet.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ "${./wallpaper.png}" ];
      wallpaper = [ ",${./wallpaper.png}" ];
    };
  };


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
