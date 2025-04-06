{ self, nix-darwin, pkgs, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }: {

  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;
    casks = [
      "betterdisplay"
      "brave-browser"
      "notion"
      "deepl"
      "hammerspoon"
    ];
    brews = [
      "colima"
      "mas" # for querying the Mac App Store: mas search "Singularity"
      "python"
      "libpq"
      "ffmpeg"
      "make"
      "ninja"
      "dfu-util"
      "helm"
      "bcrypt"
    ];

    masApps = {
      "Singularity" = 1481535767;
      "Xcode" = 497799835;
      "Ethernet Status" = 1186187538;
      "iMovie" = 408981434;
      "Wireguard" = 1451685025;
      "Parcel" = 639968404;
      "Amphetamine" = 937984704;
      "Numbers" = 409203825;
      # "1Password for Safari" = 1569813296;
    };


    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      tmux
      git
      # go
      hugo
      watch
      docker
      docker-compose
      wget
      flyctl
      ngrok
      iterm2
      obsidian
      telegram-desktop
      jq
      inetutils # telnet
      kubectl
      kubectx
      helmfile
      iperf3
      nmap
      pre-commit
      gitleaks
      devenv
      nixfmt-rfc-style
      commitizen
      hadolint
      whois
      yandex-cloud
      terraform
      gh
      minio-client
      skhd
    ];

  # darwin-help, mynixos.com
  system.defaults = {
    # dock.persistent-apps = [
    #   "/System/Library/CoreServices/Finder.app"
    #   "/System/Applications/Calendar.app"
    #   "/Applications/Firefox.app"
    #   "/System/Applications/Mail.app"
    #   "/Applications/SingularityApp.app"
    #   "${pkgs.iterm2}/Applications/iTerm2.app"
    #   "${pkgs.obsidian}/Applications/Obsidian.app"
    #   "${pkgs.telegram-desktop}/Applications/Telegram.app"
    # ];
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;

  };

  # Auto upgrade nix package.
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.extra-trusted-users = "alikkhilazhev";
  nix.settings.extra-substituters = "https://devenv.cachix.org";
  nix.settings.extra-trusted-public-keys = "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.alikkhilazhev = {
    name = "alikkhilazhev";
    home = "/Users/alikkhilazhev";
  };

  services.skhd.enable = true;
  services.skhd.package = pkgs.skhd;
  # examples here https://github.com/koekeishiya/yabai/blob/master/examples/skhdrc
  # https://github.com/koekeishiya/skhd/issues/1
  services.skhd.skhdConfig = ''
    cmd + ctrl - 0x25: skhd -k "ctrl - right"
    cmd + ctrl - 0x26: skhd -k "ctrl - left"
    cmd + ctrl - 0x22: skhd -k "ctrl - up"
    cmd + ctrl - 0x28: skhd -k "ctrl - down"
  '';

}
