{ pkgs, lib, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Dan Jordan";
    userEmail = "deej81@users.noreply.github.com";
    aliases = { };
    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };

      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfGWI6KVci/0cS45lvmv418ojhKTGEsmhsqgz8PQZ2q";
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };
    };
    # enable git Large File Storage: https://git-lfs.com/
    # lfs.enable = true;
    ignores = [ ".direnv" "result" ];
  };
}
