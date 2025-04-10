{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.unstable.aider-chat
  ];
}
