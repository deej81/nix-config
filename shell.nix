{ pkgs ? # If pkgs is not defined, instantiate nixpkgs from locked commit
  let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
  import nixpkgs { overlays = [ ]; }, ...}: 
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";

    nativeBuildInputs = with pkgs; [
      # Required for pre-commit hook 'nixpkgs-fmt' only on Darwin
      # REF: <https://discourse.nixos.org/t/nix-shell-rust-hello-world-ld-linkage-issue/17381/4>
      libiconv

      nix
      home-manager
      git
      just
      pre-commit

      age
      ssh-to-age
      sops

      # Add Python 3
      python3
      (python3.withPackages (ps: with ps; [
        jinja2
      ]))
    ];
  };
}
