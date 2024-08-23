{
  # Let it try to start a few more times
  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      layer = "top";
      position = "top";
      mod = "dock";
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;
      height = 50;
      modules-left = [ "custom/launch_wofi" "hyprland/workspaces" "cpu" "memory" "disk" "hyprland/window" ];
      modules-center = [ "custom/lock_screen" "custom/updates" "clock" "custom/power_btn" ];
      modules-right = [ "temperature" "custom/power_profile" "battery" "backlight" "pulseaudio" "pulseaudio#microphone" "tray" "custom/weather" "custom/swaync" ];

      "hyprland/window" = {
        format = "{}";
      };

      "custom/launch_wofi" = {
        format = "";
        on-click = "pkill wofi; wofi -n";
        tooltip = false;
      };

      "custom/lock_screen" = {
        format = "";
        on-click = "hyprlock";
        tooltip = false;
      };

      "custom/light_dark" = {
        format = "󰐾";
        on-click = "~/.config/waybar/scripts/baraction light";
        tooltip = false;
      };

      "custom/swaync" = {
        format = " ";
        on-click = "~/.config/swaync/scripts/tray_waybar.sh";
        tooltip = false;
      };

      "custom/power_btn" = {
        format = "";
        on-click = "sh -c '(sleep 0.5s; wlogout --protocol layer-shell)' & disown";
        tooltip = false;
      };

      cpu = {
        interval = 10;
        format = " {usage}%";
        max-length = 10;
        on-click = "kitty --start-as=fullscreen --title btop sh -c 'btop'";
      };

      disk = {
        interval = 30;
        format = "󰋊 {percentage_used}%";
        path = "/";
        tooltip = true;
        tooltip-format = "HDD - {used} used out of {total} on {path} ({percentage_used}%)";
        on-click = "kitty --start-as=fullscreen --title btop sh -c 'btop'";
      };

      memory = {
        interval = 30;
        format = " {}%";
        max-length = 10;
        tooltip = true;
        tooltip-format = "Memory - {used:0.1f}GB used";
        on-click = "kitty --start-as=fullscreen --title btop sh -c 'btop'";
      };

      "custom/updates" = {
        format = "{}";
        exec = "~/.config/waybar/scripts/update-sys";
        on-click = "~/.config/waybar/scripts/update-sys update";
        interval = 300;
        tooltip = true;
      };

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        on-click = "activate";
        persistent_workspaces = {
          "1" = [ ];
          "9" = [ ];
          "10" = [ ];
        };
        sort-by = "number";
      };

      "custom/weather" = {
        tooltip = true;
        format = "{}";
        interval = 30;
        exec = "~/.config/waybar/scripts/waybar-wttr.py";
        return-type = "json";
      };

      tray = {
        icon-size = 18;
        spacing = 10;
      };

      clock = {
        tooltip = true;
        tooltip-format = "{: %A, %B %e %Y}";
      };

      backlight = {
        device = "intel_backlight";
        format = "{icon} {percent}%";
        format-icons = [ "󰃞" "󰃟" "󰃠" ];
        on-scroll-up = "brightnessctl set 1%+";
        on-scroll-down = "brightnessctl set 1%-";
        min-length = 6;
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 20;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "";
        on-click = "pamixer -t";
        on-click-right = "pavucontrol";
        on-scroll-up = "pamixer -i 5";
        on-scroll-down = "pamixer -d 5";
        scroll-step = 5;
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
      };

      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        on-click = "pamixer --default-source -t";
        on-click-right = "pavucontrol";
        on-scroll-up = "pamixer --default-source -i 5";
        on-scroll-down = "pamixer --default-source -d 5";
        scroll-step = 5;
      };

      temperature = {
        hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        format = " {temperatureC}°C";
        critical-threshold = 70;
        format-critical = " {temperatureC}°C";
        on-click = "kitty --start-as=fullscreen --title btop sh -c 'btop'";
      };
    }];
    style = ''
      
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-weight: bold;
          font-size: 16px;
          min-height: 0;
      }

      window#waybar {
          background: rgba(21, 18, 27, 0);
          color: #cdd6f4;
      }

      tooltip {
          background: rgba(200,200,200,0.15);
          border-radius: 10px;
          border: 1px solid rgba(255, 255, 255, 0.07);
      }

      tooltip label{
          color: #cdd6f4;
      }

      #workspaces button {
          padding: 5px;
          color: #313244;
          margin-right: 5px;
      }

      #workspaces button.active {
          color: #a6adc8;
      }

      #workspaces button.focused {
          color: #a6adc8;
          background: #eba0ac;
          border-radius: 10px;
      }

      #workspaces button.urgent {
          color: #11111b;
          background: #a6e3a1;
          border-radius: 10px;
      }

      #workspaces button:hover {
          background: #11111b;
          color: #cdd6f4;
          border-radius: 10px;
      }

      #custom-launch_wofi,
      #custom-lock_screen,
      #custom-light_dark,
      #custom-power_btn,
      #custom-power_profile,
      #custom-weather,
      #custom-swaync,
      #window,
      #cpu,
      #disk,
      #custom-updates,
      #memory,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #tray,
      #temperature,
      #workspaces,
      #backlight {
          padding: 0px 10px;
          margin: 3px 0px;
          
          border: 0px;
      }

      /* this needs sorting out so the components aren't noob css */
      .modules-left,
      .modules-center,
      .modules-right {
          background: rgba(200,200,200,0.05);
          border: 1px solid rgba(255, 255, 255, 0.07);
          margin: 10px 10px 0px 10px ;
          border-radius: 10px;
      }


      #tray, #custom-lock_screen, #temperature, #backlight, #custom-launch_wofi, #cpu {
          border-radius: 10px 0px 0px 10px;
      }

      #custom-light_dark, #custom-power_btn, #workspaces, #pulseaudio.microphone, #battery, #disk, #custom-swaync {
          border-radius: 0px 10px 10px 0px;
          margin-right: 10px;
      }

      #temperature.critical {
          color: #e92d4d;
      }


      #workspaces {
          padding-right: 0px;
          padding-left: 5px;
      }

      #custom-power_profile {
          color: #a6e3a1;
          border-left: 0px;
          border-right: 0px;
      }

      #window {
          border-radius: 10px;
          margin-left: 20px;
          margin-right: 20px;
      }

      #custom-launch_wofi {
          color: #89b4fa;
          margin-left: 10px;
          border-right: 0px;
      }

      #pulseaudio {
          color: #89b4fa;
          border-left: 0px;
          border-right: 0px;
      }

      #pulseaudio.microphone {
          color: #cba6f7;
          border-left: 0px;
          border-right: 0px;
      }

      #battery {
          color: #a6e3a1;
          border-left: 0px;
      }
      '';
  };

}
