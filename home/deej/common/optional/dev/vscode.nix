
{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "git.suggestSmartCommit" = false;
      "editor.fontLigatures" = true;
    };
  };
}