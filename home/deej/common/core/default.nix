{ config, lib, pkgs, outputs, ... }:
{
  imports = [

    # Packages with custom configs go here

    ./bash.nix # backup shell
    ./bat.nix # cat with better syntax highlighting and extras like batgrep.
    ./direnv.nix # shell environment manager. Hooks inot shell direnv to look for .envrc before prompts
    ./fonts.nix # core fonts
    ./git.nix # personal git config
    ./kitty.nix # terminal
    ./nixvim # vim goodness
    ./screen.nix # hopefully rarely needed but good to have if so
    ./ssh.nix # personal ssh configs
    ./zoxide.nix # cd replacement
    ./zsh/zen.nix # primary shell: includes zsh, oh-my-zsh, and p10k theme

    # TODO: Not set, need to investigate but will need custom config if used:
    # ./shellcolor.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault "deej";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix-config";
      TERM = "kitty";
      TERMINAL = "kitty";
      EDITOR = "nvim";
      MANPAGER = "batman"; # see ./cli/bat.nix
    };
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)

      # Packages that don't have custom configs go here

      # TODO: spaces before comment are removed by nixpkgs-fmt
      # See: https://github.com/nix-community/nixpkgs-fmt/issues/305
      btop# resource monitor
      coreutils# basic gnu utils
      curl
      dnsutils
      eza# ls replacement
      fd# tree style ls
      findutils# find
      fzf# fuzzy search
      gnumake
      jq# JSON pretty printer and manipulator
      just#task runner
      lazygit# git tui
      nix-tree# nix package tree viewer
      ncdu# TUI disk usage
      pciutils
      pfetch# system info
      pre-commit# git hooks
      p7zip# compression & encryption
      ripgrep# better grep
      usbutils
      taskwarrior# task manager
      tree# cli dir tree viewer
      unzip# zip extraction
      unrar# rar extraction
      whois
      wget# downloader
      zellij# terminal multiplexer
      zip; # zip compression

  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
