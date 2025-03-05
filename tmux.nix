{ ... }:
{
  programs.tmux.enable = true;
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    prefix = "C-a";
    # reverseSplit = false;
    sensibleOnTop = true;
    terminal = "xterm-256color";
    extraConfig = ''
      set -a terminal-overrides ",xterm-256color:RGB"
      bind  c  new-window      -c "#{pane_current_path}"
      unbind '"'
      unbind %
      bind  |  split-window -h -c "#{pane_current_path}"
      bind '-' split-window -v -c "#{pane_current_path}"
      set-option -g focus-events on
    '';
  };
}
