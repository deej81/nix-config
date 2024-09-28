
# deej nix config

## issues

- [ ] fix - enable ntp
- [ ] fix swaync summary
- [ ] refactor hyprland setup into a single "desktop" package
- [ ] fix waybar power icon action
- [ ] fix weather
- [ ] auto format nix files
- [ ] demonstrate nix-anywhere install
- [x] reduce size of top bar and spacing 
- [x] fingerprint doesn't unlock 1password



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
sign into 1password
enable 1password ssh agent
congratulations, you are now holding a duck




## Acknowledgements

Based off EmergentMind's config https://github.com/EmergentMind/nix-config. There is a really nice youtube video that goes along with this, highly recommend it. 