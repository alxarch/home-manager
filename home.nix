{ config, pkgs, ... }:

{
  imports = [ ./neovim.nix ./kitty.nix ];

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
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bottom # Terminal system monitor
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # slack
    signal-desktop

    # WebStrom with GL support
    (symlinkJoin {
      name = "webstorm";
      paths = [
        (writeShellScriptBin "webstorm" ''
          ${nixgl.auto.nixGLDefault}/bin/nixGL ${unstable.jetbrains.webstorm}/bin/webstorm "$@"
        '')
        unstable.jetbrains.webstorm
      ];

    })
    # Slack with GL support
    (symlinkJoin {
      name = "slack";
      paths = [
        (writeShellScriptBin "slack" ''
          ${nixgl.auto.nixGLDefault}/bin/nixGL ${unstable.slack}/bin/slack "$@"
        '')
        unstable.slack
      ];

    })
  ];

  fonts.fontconfig.enable = true;

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
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  programs.bash = {
    enable = true;
  };
  programs.fzf = {
    enable = true;
    package = with pkgs; symlinkJoin {
      name = "fzfAndTools";
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
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "alexandros.sigalas@gmail.com";
    userName = "Alexandros Sigalas";
  };

  xdg.enable = true;
  # xdg.configFile.kitty = {
  #   source = ./kitty;
  #   recursive = true;
  # };
  targets.genericLinux.enable = true;

}