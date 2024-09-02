
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
    };
  };
}