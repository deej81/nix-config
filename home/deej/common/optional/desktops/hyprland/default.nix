{ pkgs, lib, ... }: {
  imports = [
    ./binds.nix
    ../waybar.nix
  ];

  # NOTE: xdg portal package is currently set in /hosts/common/optional/hyprland.nix

  wayland.windowManager.hyprland = {
    enable = true;

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

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        "col.active_border"="rgba(595959aa)";
        "col.inactive_border" = "rgba(22222200)";
        layout = "dwindle";
      };

      decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 5;
          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";

          blur = {
              enabled = true;
              size = 5;
              passes = 4;
              ignore_opacity = true;
              new_optimizations = true;

              blurls = [
                "lockscreen"
                "wofi"
                "swaync-control-center"
                "waybar"
              ];
          };
      };

      layerrule = [
        "ignorezero, swaync-control-center"
        "ignorezero, waybar"
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
      "width"=900;
      "height"=350;
      "location"="center";
      "show"="drun";
      "prompt"="Search...";
      "filter_rate"=100;
      "allow_markup"=true;
      "no_actions"=true;
      "halign"="fill";
      "orientation"="vertical";
      "content_halign"="fill";
      "insensitive"=true;
      "allow_images"=true;
      "image_size"=40;
      "columns"=2;
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

}
