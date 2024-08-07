#
# TODO stage 4: this is a placeholder list for now
#
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
    };
  };

}

# code



#   #TODO stage 4: Add the following packages for LSP, Linting, and Fixing as required by nvim ale (see "ale" in home/ta/core/nvim/devtools.nix )
#   ansible-language-server
#   ansible-lint
#   dockerlinter
#   gitlint
#   eslint
#   shellcheck
#   cspell
#   clangtidy
#   clang-format
#   prettier
#   cspell
#   nixfmt
#   alejandra
#   black
#   flake8
#   dprint
#   vimls
#   vint
