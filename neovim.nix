{ config, pkgs, ... }:
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
      rnix-lsp
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      marksman
      yaml-language-server
      pyright
    ];
    withNodeJs = true;
    extraLuaConfig = ''
      vim.g.mapleader = " "
    '';
    plugins = with pkgs.vimPlugins ; [
      vim-nix
      vim-lfe
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = {
              enable = true,

              -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
              -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
              -- the name of the parser)
              -- list of language that will be disabled
              -- disable = {  },
              -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
              disable = function(lang, buf)
                  local max_filesize = 100 * 1024 -- 100 KB
                  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                  if ok and stats and stats.size > max_filesize then
                      return true
                  end
              end,

              -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
              -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
              -- Using this option may slow down your editor, and you may see some duplicate highlights.
              -- Instead of true it can also be a list of languages
              additional_vim_regex_highlighting = false,
            },
          })
        '';
      }
      {
        plugin = nvim-treesitter-parsers.hurl;
        type = "lua";
        config = ''
          vim.filetype.add({
            extension = {
              hurl = "hurl"
            }
          })
          '';
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = "require('Comment').setup()";
      }
      {
        type = "lua";
        plugin = gitsigns-nvim;
        config = "require('gitsigns').setup()";
      }
      {
        plugin = tokyonight-nvim;
        config = "colorscheme tokyonight-storm";
      }
      plenary-nvim
      {
        type = "lua";
        plugin = telescope-nvim;
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        '';
      }
      {
        type = "lua";
        plugin = which-key-nvim;
        config = ''
          vim.o.timeout = true;
          vim.o.timeoutlen = 250;
          require('which-key').setup {}
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')
          lspconfig.rnix.setup {}
          lspconfig.tsserver.setup {}
          lspconfig.bashls.setup {}
          lspconfig.jsonls.setup {}
          lspconfig.cssls.setup {}
          lspconfig.html.setup {}
          lspconfig.eslint.setup {}
          lspconfig.marksman.setup {}
          lspconfig.yamlls.setup {}
          lspconfig.pyright.setup {}

          -- Global mappings.
          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

          -- Use LspAttach autocommand to only map the following keys
          -- after the language server attaches to the current buffer
          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
              -- Enable completion triggered by <c-x><c-o>
              vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

              -- Buffer local mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local opts = { buffer = ev.buf }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set('n', '<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, opts)
              vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<leader>F', function()
                vim.lsp.buf.format { async = true }
              end, opts)
            end,
          })
        '';
      }
    ];

  };
}
