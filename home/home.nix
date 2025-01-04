# home.nix

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    python3
    pyenv

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".hammerspoon/init.lua".text = ''
        hs.caffeinate.watcher.new(function(eventType)
            if eventType == hs.caffeinate.watcher.screensDidUnlock then
                -- Run your script here
                hs.execute("/Users/alikkhilazhev/nix/home/scripts/show-wait.script")
            end
          end
        ):start()
      '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nano";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "git@alik.page";
    userName = "Alik Khilazhev";
    ignores = [ "*~" ".DS_Store" ];
    extraConfig = {
      core = {
        editor = "nano";
      };
    };
  };

programs.zsh = {
    # https://rycee.gitlab.io/home-manager/options.xhtml#opt-programs.zsh.enable
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "direnv"
        "kube-ps1"
        "git"
      ];
    };
    shellAliases = import ../common/aliases.nix // import ./aliases.nix;
    initExtra = ''
      bindkey -e
      bindkey '^[[1;9C' forward-word
      bindkey '^[[1;9D' backward-word

      PROMPT='$(kube_ps1)'$PROMPT # or RPROMPT='$(kube_ps1)'
    '';
  };

}
