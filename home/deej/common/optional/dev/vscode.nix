{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "workbench.colorTheme" = "Default Dark Modern";
      "git.suggestSmartCommit" = false;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', Consolas, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
      "update.mode" = "none";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.fontSize" = 16;
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', Consolas, 'Courier New', monospace";
        };
    };
  }
