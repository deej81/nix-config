{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.elixir
    pkgs.erlang
  ];
}
