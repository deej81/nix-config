# Spotify media player

{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.spotify
  ];
}
