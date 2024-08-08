{ pkgs,... }:
{
  programs.neovim = {
    enable = true;
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
      unstable.nil
      unstable.nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      marksman
      yaml-language-server
      unstable.pyright
      elixir-ls
      lazygit
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
      {
        plugin = tokyonight-nvim;
        config = "colorscheme tokyonight-storm";
      }
      plenary-nvim
      nvim-web-devicons
      telescope-nvim
      which-key-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      vim-vsnip
      cmp-vsnip
      conjure
    ];

  };
}
