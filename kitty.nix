{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    package = with pkgs; symlinkJoin {
      name = "kitty";
      paths = [
        (writeShellScriptBin "kitty" ''
          ${nixgl.auto.nixGLDefault}/bin/nixGL ${unstable.kitty}/bin/kitty "$@"
        '')
        unstable.kitty
      ];
    };
    font = {
      name = "FiraCode Nerd Font";
      size = 16;
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
    };
    shellIntegration.mode = "enabled";
    keybindings = {
      "kitty_mod+enter" = "launch --cwd=current";
    };
    settings = {
      enabled_layouts = "tall:bias=50;full_size=1;mirrored=false,stack,fat:bias=50;full_size=1;mirrored=false";
      hide_window_decorations = true;
      copy_on_select = true;
    };
    theme = "Tokyo Night Day";
  };
}
