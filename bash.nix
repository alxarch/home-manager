{ config, pkgs, ... }:
{

  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "ignorespace" "ignoredups" ];
    historyIgnore = [ "ls" "cd" "exit"];
    shellAliases = {
      ".." = "cd ..";
      "g" = "git";
      "rm" = "echo 'rm is disabled. Use trash of rmi'";
      "rmi" = "${pkgs.coreutils}/bin/rm -i";
    };
    initExtra = ''
          # enable vi editing
          set -o vi

          # Create a directory and cd into it. 
          # Makes a termporary directory if no name is provided
          function mkcd { if [ -z "$1" ]; then cd "$(mktemp -d)"; else mkdir -p "$1" && cd "$1"; fi }
    '';
  };
}
