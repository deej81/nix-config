{ pkgs, lib, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Dan Jordan";
        email = "deej81@users.noreply.github.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfGWI6KVci/0cS45lvmv418ojhKTGEsmhsqgz8PQZ2q";
      };
      alias = { };
      init.defaultBranch = "main";
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
