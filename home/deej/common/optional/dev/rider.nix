{ pkgs, ... }:
{
  home.packages = [
    pkgs.jetbrains.rider
  ];

  # Hyprland window rules for JetBrains Rider compatibility
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "tag +jb, class:^jetbrains-.+$,floating:1"
    "stayfocused, tag:jb"
    "noinitialfocus, tag:jb"
  ];
}
