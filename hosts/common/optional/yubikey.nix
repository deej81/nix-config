{ pkgs, ... }:
{
  # Enable PC/SC Smart Card daemon for YubiKey communication
  services.pcscd.enable = true;

  # Add udev rules for proper USB device permissions
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # YubiKey management and support tools
  environment.systemPackages = with pkgs; [
    yubikey-manager           # ykman CLI tool
    yubikey-personalization   # ykpersonalize tool
    yubico-piv-tool          # PIV smart card functionality
    opensc                    # PKCS#11 support for smart cards
    pcsctools                 # Tools for testing PC/SC interface
    age-plugin-yubikey       # For age encryption with YubiKey
  ];

  # Configure GnuPG agent for YubiKey SSH authentication
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
