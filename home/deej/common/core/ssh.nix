{ outputs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        # Disable password authentication for security
        extraOptions = {
          PasswordAuthentication = "no";
          PubkeyAuthentication = "yes";
          # Standard home-manager defaults
          HashKnownHosts = "no";
          Compression = "no";
        };
      };
      # "temp" = {
      #   host = "<IP ADDRESS>";
      #   proxyJump = "user@host";
      # };
    };
  };
}
