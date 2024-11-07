{ outputs, lib, ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      # "temp" = {
      #   host = "<IP ADDRESS>";
      #   proxyJump = "user@host";
      # };
    };
  };
}
