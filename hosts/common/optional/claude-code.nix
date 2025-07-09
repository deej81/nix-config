{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.unstable.claude-code
  ];
}
