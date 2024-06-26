# hosts level sops. see home/[user]/common/optional/sops.nix for home/user level

{ inputs, config, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets.yml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/age.key";
      generateKey = true;
    };

    secrets = {
      github-email = { };
    };
  };
}
