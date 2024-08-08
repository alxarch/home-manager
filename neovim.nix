{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
    extraPackages = with pkgs; [
      cargo
      python3
      go
      ripgrep
      xsel
      zig
      fd
      shfmt
      lua-language-server
      stylua
      unstable.nil
      unstable.nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      marksman
      yaml-language-server
      unstable.pyright
      elixir-ls
      lazygit
      ruff
    ];
    withNodeJs = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = builtins.readFile ./neovim/init.lua;
    plugins = with pkgs.vimPlugins ; [
      vim-nix
      vim-lfe
      nvim-treesitter.withAllGrammars
      nvim-treesitter-parsers.elixir
      nvim-treesitter-parsers.hurl
      comment-nvim
      lualine-nvim
      gitsigns-nvim
      tokyonight-nvim
      plenary-nvim
      nvim-web-devicons
      telescope-nvim
      pkgs.unstable.vimPlugins.which-key-nvim
      pkgs.unstable.vimPlugins.nvim-lspconfig
      # nvim-cmp
      # cmp-nvim-lsp
      # cmp-buffer
      # cmp-path
      # cmp-cmdline
      # cmp-git
      # lsp-zero-nvim
      # cmp_luasnip
      # luasnip
      # conjure
      pkgs.unstable.vimPlugins.none-ls-nvim
      pkgs.unstable.vimPlugins.vim-dadbod
      pkgs.unstable.vimPlugins.vim-dadbod-ui
      pkgs.unstable.vimPlugins.vim-dadbod-completion
    ];

  };
}
