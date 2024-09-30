SOPS_FILE := "../nix-secrets/secrets.yaml"

# default recipe to display help information
default:
  @just --list

rebuild-pre:
	nix flake lock --update-input nixvim-flake
	just update-nix-secrets
	git add *.nix

rebuild-post:
	just check-sops

# Add --option eval-cache false if you end up caching a failure you can't get around
rebuild:
	just rebuild-pre
	scripts/system-flake-rebuild.sh
	just rebuild-post

rebuild-full:
	just rebuild-pre
	scripts/system-flake-rebuild.sh
	just rebuild-post

rebuild-trace:
	just rebuild-pre
	scripts/system-flake-rebuild-trace.sh
	just rebuild-post

update:
	nix flake update

rebuild-update:
	just update
	just rebuild

diff:
	git diff ':!flake.lock'

# Run ci using pre-commit
ci:
  pre-commit run

# Run ci for all files using pre-commit
ci-all:
  pre-commit run --all-files

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

update-nix-secrets:
	(cd ~/src/nix-secrets && git fetch && git rebase) || true
	nix flake lock --update-input nix-secrets

#################### Installation ####################

build-iso:
    nix run nixpkgs#nixos-generators -- --format iso --flake .#installerISO -o result




@sync USER HOST PORT='22':
	rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}} -p {{PORT}}" . {{USER}}@{{HOST}}:nix-config/

# copy remote hardware and configuration to local folder
new-host USER HOSTNAME IP PORT='22':
	echo "{{USER}} {{HOSTNAME}} {{ IP }}"
	mkdir -p hosts/{{HOSTNAME}}
	scp -P {{PORT}} -r {{USER}}@{{IP}}:/etc/nixos hosts/{{HOSTNAME}}/imported

bootstrap-vm:
	# copy ssh key first
	scp -P22220 -r hosts/vm/imported/ nixos@localhost:~/nix-config
	ssh -p22220 nixos@localhost 'bash -s' < ./scripts/bootstrap-vm.sh

	# on the machine you must now set a password for the user
	# `sudo nix-enter` chroots into the installation
	# `sudo passwd {user}` sets the password for the user 



