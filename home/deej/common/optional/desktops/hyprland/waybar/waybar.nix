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
      height = 32;
      modules-left = [ "custom/launch_wofi" "hyprland/workspaces" "cpu" "memory" "disk" "custom/git_unclean" "hyprland/window" ];
      modules-center = [ ];
      modules-right = [ "temperature" "custom/power_profile" "battery" "backlight" "pulseaudio" "pulseaudio#microphone" "tray" "custom/weather" "clock" "custom/swaync" ];

      "hyprland/window" = {
        format = "{}";
      };

      "custom/git_unclean" = {
        exec = "${./unclean_git.sh} | jq --unbuffered --compact-output";
        interval = 60;
        return-type = "json";
        format = "{}";
        tooltip = true;
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
        on-click = "swaync-client -t";
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
    style = ./style.css;
  };

}
