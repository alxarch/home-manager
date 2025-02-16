{ pkgs, ... }:
{
  services.gpg-agent.enable = true;

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

  home.packages = [ pkgs.trash-cli ];
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "ignorespace" "ignoredups" ];
    historyIgnore = [ "ls" "cd" "exit" ];
    shellAliases =
      # Wrap destructive file operations to force --interactive
      let wrapInteractive = name:
        let
          app = pkgs.writeShellApplication {
            inherit name;
            runtimeInputs = with pkgs; [ coreutils ];
            text = ''
              ${name} "''$@" --interactive
            '';
          }; in
        "${app}/bin/${name}";
      in

      {
        ".." = "cd ..";
        "g" = "git";
        "rm" = (wrapInteractive "rm");
        "mv" = (wrapInteractive "mv");
      };
    initExtra = ''
      # enable vi editing
      set -o vi
      # This will raise an error if you try to overwrite an existing file by output redirection.
      # You can force the redirection to work with special syntax: 
      #   $ echo "Foo" >| existing_file
      set -o noclobber

      # Create a directory and cd into it. 
      # Makes a termporary directory if no name is provided
      function mkcd { if [ -z "$1" ]; then cd "$(mktemp -d)"; else mkdir -p "$1" && cd "$1"; fi }
    '';
  };
}
