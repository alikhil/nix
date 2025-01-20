# home.nix

{ config, pkgs, nixpkgs, lib, ... }:

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
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    shfmt
    # zsh

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
  home.file = { };

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
    KUBECONFIG = "/Users/a.khilazhev/.kube/config.yaml";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "a.khilazhev@criteo.com";
    userName = "Alik Khilazhev";
    ignores = [ "*~" ".DS_Store" ];
    extraConfig = {
      core = {
        editor = "nano";
      };
      url = {
        "git@gitlab.iponweb.net:" = {
          insteadOf = "https://gitlab.iponweb.net/";
        };
      };
      # pull = {
      #   rebase = true;
      # };
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
      ];
    };
    shellAliases = import ../common/aliases.nix // import ./aliases.nix;
    initExtra = ''
      . "''${HOME}/.secret-env";
      bindkey -e
      bindkey '^[[1;9C' forward-word
      bindkey '^[[1;9D' backward-word

      PROMPT='$(kube_ps1)'$PROMPT # or RPROMPT='$(kube_ps1)'
    '';
  };

  programs.vscode = {
    # https://nixos.wiki/wiki/Visual_Studio_Code
    # https://home-manager-options.extranix.com/?query=vscode&release=release-24.05
    enable = true;

    extensions = with pkgs.vscode-marketplace; [
      adamhartford.vscode-base64
      adpyke.codesnap
      ahmadalli.vscode-nginx-conf
      bbenoist.nix
      chireia.darker-plus-material-red
      christian-kohler.npm-intellisense
      christian-kohler.path-intellisense
      danijel-grabez.transliterate
      davidanson.vscode-markdownlint
      dotjoshjohnson.xml
      dunstontc.dark-plus-syntax
      eamodio.gitlens
      earshinov.permute-lines
      ecmel.vscode-html-css
      editorconfig.editorconfig
      esbenp.prettier-vscode
      exiasr.hadolint
      fisheva.eva-theme
      foxundermoon.shell-format
      fredwangwang.vscode-hcl-format
      github.copilot
      golang.go
      hangxingliu.vscode-nginx-conf-hint
      hashicorp.hcl
      hashicorp.terraform
      jinliming2.vscode-go-template
      jock.svg
      jq-syntax-highlighting.jq-syntax-highlighting
      jsynowiec.vscode-insertdatestring
      jtcontreras90.yaml-path-extractor
      kevinrose.vsc-python-indent
      mads-hartmann.bash-ide-vscode
      magicstack.magicpython
      mechatroner.rainbow-csv
      mikestead.dotenv
      mitchdenny.ecdc
      ms-azuretools.vscode-docker
      ms-python.debugpy
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.vscode-remote-extensionpack
      ms-vscode.makefile-tools
      ms-vscode.remote-explorer
      ms-vscode.remote-server
      ms-vsliveshare.vsliveshare
      quicktype.quicktype
      raynigon.nginx-formatter
      redhat.vscode-commons
      redhat.vscode-xml
      redhat.vscode-yaml
      rogalmic.zsh-debug
      s-shemmee.dark-violetta
      samuelcolvin.jinjahtml
      streetsidesoftware.code-spell-checker
      tamasfe.even-better-toml
      technosophos.vscode-helm
      tim-koehler.helm-intellisense
      tinkertrain.theme-panda
      visualstudioexptteam.intellicode-api-usage-examples
      visualstudioexptteam.vscodeintellicode
      vivaxy.vscode-conventional-commits
      vscode-icons-team.vscode-icons
      william-voyek.vscode-nginx
      wk-j.vscode-httpie
      wmaurer.change-case
      wsds.theme-hacker
      wyattferguson.jinja2-snippet-kit
      yummygum.city-lights-theme
      zhuangtongfa.material-theme
      zxh404.vscode-proto3
      bbenoist.nix
      puppet.puppet-vscode
      grafana.vscode-jsonnet
    ];
    userSettings =
      builtins.fromJSON (builtins.readFile ../common/vscode/settings.json) //
      builtins.fromJSON (builtins.readFile ./vscode/settings.json)
    ;

  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    matchBlocks = {
      "*.iponweb.net" = {
        user = "akhilazhev_criteo";
        forwardAgent = true;
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };
    };

    extraConfig = ''
      Include /Users/a.khilazhev/.colima/ssh_config
    '';
  };

  programs.direnv = {
    enable = true;
    config = builtins.fromTOML ''
      [whitlest]
      prefix = ["/Users/a.khilazhev/projects/iponweb"]
    '';
  };
}
