
{ config, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    package = with pkgs; wrapNixGL {
      name = "alacritty";
      package = pkgs.alacritty;
    };
    settings = with pkgs.lib; mkMerge [
      {
        selection.save_to_clipboard = true;
        keyboard.bindngs = [
          {
            key = "F";
            mods = "Super";
            action = "ToggleFullscreen";
          }
        ];
      }
      (mkIf config.fonts.fontconfig.enable {
      font.normal.family = "SauceCodePro Nerd Font";
      })
    ];
  };
}
