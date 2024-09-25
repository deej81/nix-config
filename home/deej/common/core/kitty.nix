{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    # Define the color scheme
    settings = {

      background = "#202020";
      foreground = "#d0d0d0";
      cursor = "#d0d0d0";
      selection_background = "#303030";
      selection_foreground = "#202020";

      color0 = "#151515";
      color1 = "#ac4142";
      color2 = "#188A0E";
      color3 = "#e5b566";
      color4 = "#6c99ba";
      color5 = "#9e4e85";
      color6 = "#7dd5cf";
      color7 = "#d0d0d0";

      color8 = "#505050";
      color9 = "#ac4142";
      color10 = "#188A0E";
      color11 = "#e5b566";
      color12 = "#6c99ba";
      color13 = "#9e4e85";
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
