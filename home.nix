{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alxarch";
  home.homeDirectory = "/home/alxarch";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bottom # Terminal system monitor
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello


    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # slack
    # signal-desktop

    # unstable.vscode
    # unstable.masterpdfeditor
    # unstable.jetbrains.webstorm
    aws-vault
    awscli
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
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alxarch/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    AWS_VAULT_BACKEND = "pass";
    AWS_VAULT_PASS_CMD = "${config.programs.password-store.package}/bin/pass";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.gpg.enable = true;
  programs.gpg.mutableTrust = true;
  programs.gpg.mutableKeys = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-curses;
  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);

  programs.fzf = {
    enable = true;
    package = with pkgs; symlinkJoin {
      name = "fzfAndTools";
      meta.mainProgram = fzf.meta.mainProgram;
      inherit (fzf) version;
      paths = [ fzf fd tree bat ];
    };
    enableBashIntegration = true;
    changeDirWidgetCommand = "fd --type directory --hidden --exclude .git";
    changeDirWidgetOptions = [ "--preview='tree -C {} | head -200'" ];
    fileWidgetCommand = "fd --type file --hidden --exclude .git";
    fileWidgetOptions = [
      "--delimiter='/'"
      "--ansi"
      "--cycle"
      "--with-nth=-2,-1"
      "--layout=reverse"
      "--preview='bat --color=always --style=numbers --line-range=:500 {}'"
    ];
    historyWidgetOptions = [
      "--ansi"
      "--cycle"
      "--layout=reverse"
    ];
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    # enableBashIntegration = true;
  };


  programs.ripgrep.enable = true;

  targets.genericLinux.enable = true;
  xdg.enable = true;
  xdg.configFile.alacritty = {
    source = ./config/alacritty;
    recursive = true;
  };

  services.darkman.enable = true;
  services.darkman.darkModeScripts.alacritty-theme = ''
    if type -P "alacritty" &>/dev/null; then
      alacritty msg config "$(cat ${config.xdg.configHome}/alacritty/themes/github_dark_high_contrast.toml)"
    fi
  '';
  services.darkman.lightModeScripts.alacritty-theme = ''
    if type -P "alacritty" &>/dev/null; then
      alacritty msg config "$(cat ${config.xdg.configHome}/alacritty/themes/github_light_high_contrast.toml)"
    fi
  '';



}
