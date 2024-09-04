
# deej nix config

## issues

- [x] fix desktops "0"
- [x] fix monitor per host config hyprland
- [ ] fix - enable ntp
- [x] fix firefox config
- [ ] fix swaync summary
- [ ] refactor hyprland setup into a single "desktop" package
- [ ] fix waybar power icon action
- [ ] fix weather
- [ ] auto format nix files
- [ ] fix LUKS prompt appearing before keyboard is recognised
- [x] fix warnings after upgrade

## provisioning a new machine

install from iso - select no desktop
edit configuration.nix
```

environment.systemPackages = with pkgs; [                  
    vim                
    wget                  
    git                  
    direnv                  
];                  
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
enable ssh for ease
write key to authorized keys file
clone the repo
run `just age-key-from-host-key`
put that in .sops.yaml on an active machine
run `just rekey-secrets` on the active machine commit, push and pull on new machine
comment out firefox bookmarks secrets (bug)
run rebuild switch
bring back bookmarks and switch again
reboot
enjoy working config




## Acknowledgements

Based off EmergentMind's config https://github.com/EmergentMind/nix-config. There is a really nice youtube video that goes along with this, highly recommend it. 