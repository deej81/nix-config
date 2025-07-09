# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### System Management
- `just rebuild` - Rebuild and switch to the new NixOS configuration
- `just install <IP> <FLAKE>` - Install NixOS configuration on a remote machine using nix-anywhere
- `just update <IP> <FLAKE>` - Update a remote machine's configuration
- `just build-iso` - Build a custom NixOS installer ISO

### Development
- `nix develop` - Enter development shell with all tools (just, sops, age, etc.)
- `nix fmt` - Format all Nix files using nixpkgs-fmt
- `nixos-rebuild switch --flake .#<hostname>` - Rebuild specific host configuration

### Secrets Management
- `just get-host-key <IP>` - Extract host key and convert to age public key for SOPS
- `just rekey-secrets` - Re-encrypt secrets after adding new keys
- `just edit-secrets` - Edit encrypted secrets file
- `just sops-from-op` - Extract SOPS key from 1Password

### Hardware Configuration
- `just get-hardware-config <IP> <NAME>` - Generate hardware configuration for new machine

## Architecture

### Configuration Structure
- **flake.nix**: Main flake configuration defining all NixOS systems and inputs
- **hosts/**: Per-machine configurations (cheryl, mini790, nyx, bjorn, framework13)
- **home/**: Home Manager configurations for user environments
- **vars/**: Global variables and configuration values
- **secrets.yml**: SOPS-encrypted secrets file

### Modular Design
- **hosts/common/core/**: Core system modules (locale, nix settings, SOPS)
- **hosts/common/optional/**: Optional system features (desktop, development tools)
- **home/deej/common/core/**: Core user environment (bash, git, kitty, nixvim)
- **home/deej/common/optional/**: Optional user features (browsers, development, media)

### Key Components
- **SOPS**: Secrets management using age encryption with host keys
- **Disko**: Declarative disk partitioning for automated installs
- **Home Manager**: User environment management integrated with NixOS
- **Hyprland**: Wayland compositor with custom configuration

### Host Profiles
- **cheryl**: Development lab machine
- **mini790**: Mini PC configuration
- **nyx**: Main workstation with disk encryption
- **bjorn**: Standard desktop configuration
- **framework13**: Framework laptop with hardware-specific settings

### Development Environment
The repository includes a development shell (shell.nix) with essential tools:
- Nix development tools (nil LSP, home-manager)
- Secrets management (sops, age, ssh-to-age)
- Build tools (just, git, pre-commit)
- Python 3 with jinja2 for templating

### Provisioning Workflow
1. Boot target machine from custom ISO
2. Get host key: `just get-host-key <IP>`
3. Add age key to .sops.yaml
4. Rekey secrets: `just rekey-secrets`
5. Install: `just install <IP> <FLAKE>`