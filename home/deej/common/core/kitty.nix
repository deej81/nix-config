{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    # Define the color scheme
    settings = {

      background = "#000000";
      foreground = "#cdd6f4";
      cursor = "#d0d0d0";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";

      color0 = "#151515";
      color1 = "#F38BA8";
      color2 = "#a6e3a1";
      color3 = "#F9E2AF";
      color4 = "#6c99ba";
      color5 = "#cba6f7";
      color6 = "#7dd5cf";
      color7 = "#d0d0d0";

      color8 = "#808080";
      color9 = "#F38BA8";
      color10 = "#a6e3a1";
      color11 = "#F9E2AF";
      color12 = "#6c99ba";
      color13 = "#cba6f7";
      color14 = "#7dd5cf";
      color15 = "#f5f5f5";

      # Font settings
      font_family = "JetBrains Mono Nerd Font";
      font_size = 15;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Mouse and cursor settings
      mouse_hide_wait = "2.0";
      cursor_shape = "block";

      # URL settings
      url_color = "#0087BD";
      url_style = "dotted";

      # Terminal behavior settings
      confirm_os_window_close = 0;

      # Appearance settings
      background_opacity = "0.15";
      window_padding_width = 10;
    };
  };
}
