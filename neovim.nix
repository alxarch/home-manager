{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
    extraPackages = with pkgs.unstable; [
      cargo
      go
      ripgrep
      xsel
      zig
      fd
      shfmt
      lua-language-server
      stylua
      nil
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      marksman
      yaml-language-server
      elixir-ls
      lazygit
      codespell

      python3
      pyright
      python3Packages.python-lsp-server
      python3Packages.python-lsp-black
      python3Packages.pylsp-mypy
      python3Packages.pylsp-rope
      python3Packages.pyls-isort
      ruff
      xkb-switch
    ];
    withNodeJs = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = builtins.readFile ./neovim/init.lua;
    plugins = with pkgs.unstable.vimPlugins ; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-treesitter-parsers.elixir
      nvim-treesitter-parsers.hurl
      gitsigns-nvim
      comment-nvim
      tokyonight-nvim
      conform-nvim
      vim-nix
      fzf-vim
      which-key-nvim

      plenary-nvim
      nvim-web-devicons
      telescope-nvim
      # pkgs.unstable.vimPlugins.none-ls-nvim
      # pkgs.unstable.vimPlugins.vim-dadbod
      # pkgs.unstable.vimPlugins.vim-dadbod-ui
      # pkgs.unstable.vimPlugins.vim-dadbod-completion
    ];

  };
}
