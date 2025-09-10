{ pkgs, configVars, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        ms-python.python
        github.copilot
      ];
      userSettings = {
        "files.autoSave" = "afterDelay";
        "workbench.colorTheme" = "Default Dark Modern";
        "git.suggestSmartCommit" = false;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', Consolas, 'Courier New', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = configVars.fontSizes.editor;
        "update.mode" = "none";
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.fontSize" = configVars.fontSizes.terminal;
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', Consolas, 'Courier New', monospace";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "markdown" = true;
          "scminput" = false;
        };
        "files.associations" = {
          "justfile" = "makefile";
        };

        "typescript.updateImportsOnFileMove.enabled" = "always";
      };
    };
  };
}
