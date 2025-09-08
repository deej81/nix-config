
# deej nix config

## provisioning a new machine

boot from custom iso

```bash
just get-host-key <ip>
# add key to .sops.yaml
just rekey-secrets
just install <IP> <FLAKE> 
```

## Acknowledgements

Based off EmergentMind's config https://github.com/EmergentMind/nix-config. There is a really nice youtube video that goes along with this, highly recommend it. 