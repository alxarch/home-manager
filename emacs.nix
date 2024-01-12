{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    mupdf
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-gtk3;
    extraPackages = epkgs: [
      epkgs.typescript-mode
      epkgs.nix-mode
      epkgs.nixpkgs-fmt
      epkgs.magit
      epkgs.which-key
    ];
    extraConfig = (builtins.readFile ./emacs.el) + ''
      (setq org-plantuml-jar-path "${pkgs.plantuml}/lib/plantuml.jar")
      (setq org-ditaa-jar-path "${pkgs.ditaa}/lib/ditaa.jar")
    '';
  };

}
