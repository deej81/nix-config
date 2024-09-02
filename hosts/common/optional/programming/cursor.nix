{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.cursor
  ];
}
