{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.unstable.aider-chat.overrideAttrs (oldAttrs: {
      version = "0.75.2";
      src = pkgs.fetchFromGitHub {
        owner = "Aider-AI";
        repo = "aider";
        tag = "v0.75.2";
        hash = "sha256-JXzkvuSOOEUxNqF6l5USzIPftpnIW+CptEv/0yp0eGM=";
      };
    }))
  ];
}
