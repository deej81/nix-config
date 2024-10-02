SOPS_FILE := "../nix-secrets/secrets.yaml"

# default recipe to display help information
default:
  @just --list

install IP FLAKE PORT="22":
    nix run github:nix-community/nixos-anywhere -- --copy-host-keys --flake .#{{FLAKE}} --debug --ssh-port {{PORT}} nixos@{{IP}}

reinstall IP FLAKE PORT="22":
    nix run github:nix-community/nixos-anywhere -- --copy-host-keys --flake .#{{FLAKE}} --debug --ssh-port {{PORT}} root@{{IP}}

update IP FLAKE PORT="22":
    NIX_SSHOPTS="-p {{PORT}}" nixos-rebuild switch --flake .#{{FLAKE}} --target-host root@{{IP}}


#### provisioning new machines ####
# To add previously unknown hardware, build the iso and boot the machine into it, run this against the IP of the machine
get-hardware-config IP NAME PORT="22" USER="nixos":
    mkdir -p hosts/{{NAME}}
    ssh -p {{PORT}} {{USER}}@{{IP}} 'nixos-generate-config --no-filesystems --show-hardware-config' >> hosts/{{NAME}}/hardware-configuration.nix

# Retrieves the host key of the machine and outputs the age public key
get-host-key IP PORT="22":
    #!/usr/bin/env sh
    echo "Scanning {{IP}} for its ed25519 host key..."
    HOST_KEY=$(ssh-keyscan -p {{PORT}} -t ed25519 {{IP}} 2>/dev/null | grep ssh-ed25519 | awk '{print $2 " " $3}')
    echo "Host key: $HOST_KEY"
    echo "Add the following age key to your sops config and rekey the secrets:"
    echo $HOST_KEY | ssh-to-age

#################### Home Manager ####################

# Run `home-manager --impure --flake . switch` and `just check-sops`
home:
  # HACK: This is is until the home manager bug is fixed, otherwise any adding extensions deletes all of them
  # rm $HOME/.vscode/extensions/extensions.json || true
  home-manager --impure --flake . switch
  just check-sops

# Run `just update` and `just home`
home-update:
  just update
  just home

#################### Secrets Management ####################
sops:
  @echo "Editing {{SOPS_FILE}}"
  nix-shell -p sops --run "SOPS_AGE_KEY_FILE=~/.age-key.txt sops {{SOPS_FILE}}"

# Maybe redundant, but this was used to generate the key on the system that is actually
# managing secrets.yaml. If you don't want to use existing ssh key
sops-init:
  mkdir -p ~/.config/sops/age
  nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"

# Run on a new host to get a public key to add to .sops.yaml
age-key-from-host-key:
  ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub

# Extract age key from ssh key stored in 1Password
sops-from-op:
	mkdir -p ~/.config/sops/age
	op read "op://Personal/NIX Secrets/private key?ssh-format=openssh" | ssh-to-age -private-key -o ~/.config/sops/age/keys.txt

# Used to generate for the host to decrypt via home-manager
age-keys:
  nix-shell -p age --run "age-keygen -o ~/.age-key.txt"

# Check for successful sops activation.
check-sops:
  scripts/check-sops.sh

rekey-secrets:
    SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys secrets.yml

edit-secrets:
    SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --config .sops.yaml secrets.yml

update-nix-secrets:
	(cd ~/src/nix-secrets && git fetch && git rebase) || true
	nix flake lock --update-input nix-secrets

#################### Installation ####################

build-iso:
    nix run nixpkgs#nixos-generators -- --format iso --flake .#installerISO -o result

@sync USER HOST PORT='22':
	rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}} -p {{PORT}}" . {{USER}}@{{HOST}}:nix-config/

bootstrap-vm:
	# copy ssh key first
	scp -P22220 -r hosts/vm/imported/ nixos@localhost:~/nix-config
	ssh -p22220 nixos@localhost 'bash -s' < ./scripts/bootstrap-vm.sh

	# on the machine you must now set a password for the user
	# `sudo nix-enter` chroots into the installation
	# `sudo passwd {user}` sets the password for the user 



