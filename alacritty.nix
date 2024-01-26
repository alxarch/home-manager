
{ config, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    package = with pkgs; wrapNixGL {
      name = "alacritty";
      package = unstable.alacritty;
    };
    settings  = {

    };
  };
}
