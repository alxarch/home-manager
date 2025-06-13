{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    difftastic
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      rerere.enabled = true;
      rerere.autoupdate = true;
      init.defaultBranch = "main";
      push.default = "simple";
      push.autoSetupRemote = true;
      push.followTags = true;
      pull.rebase = true;
      pull.ff = "only";
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;

      rebase.autoSquash = true;
      rebase.autoStash = true;
      # Move refs of stacked branches above when rebasing 
      rebase.updateRefs = true;

      help.autocorrect = "prompt";
      log.date = "iso";
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
  programs.jujutsu.package = pkgs.unstable.jujutsu;
  programs.jujutsu.settings = {
      user.email = config.programs.git.userEmail;
      user.name = config.programs.git.userName;
      ui.diff.tool = [ "difft" "--color=always" "$left" "$right" ];
  };
}
