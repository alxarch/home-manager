{ pkgs, ... }:
{

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

}
