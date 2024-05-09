{
  programs.ssh = {
      extraConfig = ''
        Host *
            IdentityAgent ${onePassPath}
      '';
    };
}