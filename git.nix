{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    difftastic
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      pull.rebase = true;
      rerere.enabled = true;
      init.defaultBranch = "main";
    };
    userEmail = "alexandros.sigalas@gmail.com";
    userName = "Alexandros Sigalas";

    difftastic.enable = true;
  };
  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    git.paging.externalDiffCommand = "difft --color=always";
  };

  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
      user.email = config.programs.git.userEmail;
      user.name = config.programs.git.userName;
      ui.diff.tool = [ "difft" "--color=always" "$left" "$right" ];
  };
}
