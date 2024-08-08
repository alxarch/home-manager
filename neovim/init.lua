vim.cmd([[colorscheme tokyonight]])
vim.o.cmdheight = 0
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.completeopt = "menu,menuone,preview"
vim.g.mapleader = " "
vim.g.localeader = "\\"
-- Your DBUI configuration
vim.g.db_ui_use_nerd_fonts = 1
vim.keymap.set("i", "jj", "<Esc>")
vim.filetype.add({
	extension = {
		hurl = "hurl",
	},
})

require("lualine").setup()
require("Comment").setup()
require("gitsigns").setup()
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = {  },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(_, buf)
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

-- which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
local wk = require("which-key")
local telescope = require("telescope")
telescope.setup({})
local builtin = require("telescope.builtin")
wk.setup({})
wk.add({
	{ "<leader>f", group = "Find stuff" },
	{ "<leader>ff", builtin.find_files, desc = "Find files" },
	{ "<leader>fg", builtin.live_grep, desc = "Grep files" },
	{ "<leader>fr", builtin.oldfiles, desc = "Recent files" },
	{ "<leader>fh", builtin.help_tags, desc = "Find help" },
	{ "<leader><Space>", builtin.buffers, desc = "Find buffer" },
	{ "[d", vim.diagnostic.goto_prev, desc = "Go to prev diagnostic" },
	{ "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
	{ "<leader>e", vim.diagnostic.open_float, desc = "Show diagnostics" },
	{ "<leader>q", vim.diagnostic.setloclist, desc = "Show diagnostics locations" },
	{ "<leader>D", vim.lsp.buf.type_definition, desc = "Go to type definition" },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Show code actions" },
	{ "<a-CR>", vim.lsp.buf.code_action, desc = "Show code actions", mode = { "i" } },
	{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename symbol" },
	{ "<leader>w", group = "Workspace" },
	{ "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folders" },
	{ "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folders" },
	{
		"<leader>wl",
		function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,
		desc = "List workspace folders",
	},
	{
		"<leader>F",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		desc = "Format buffer",
	},
	{ "<C-k>", vim.lsp.buf.signature_help, desc = "Show signature help" },
	{ "K", vim.lsp.buf.hover, desc = "Show hover help" },
	{ "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
	{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
	{ "gd", vim.lsp.buf.definition, desc = "Go to definition" },
	{ "gr", vim.lsp.buf.references, desc = "Go to references" },
})

local setup_lsp = function(name, config)
	local lspconfig = require("lspconfig")
	-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
	lspconfig[name].setup(vim.tbl_extend("force", {  }, config or {}))
end

setup_lsp("nil_ls")
setup_lsp("tsserver")
setup_lsp("bashls")
setup_lsp("jsonls")
setup_lsp("cssls")
setup_lsp("lua_ls", {
	settings = {
		Lua = {},
	},
	on_init = function(client)
		local w = client.workspace_folders

		if w then
			local path = w[1].name
			if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end
		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
})
setup_lsp("eslint")
setup_lsp("marksman")
setup_lsp("yamlls")
setup_lsp("ruff")
setup_lsp("pyright")
setup_lsp("elixirls", {
	cmd = { "elixir-ls" },
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = { buffer = ev.buf, silent = true, noremap = true}
        opts.desc = "Autocomplete with LSP"
		vim.keymap.set("i", "<Tab>", function()
                if vim.fn.pumvisible() then
                        vim.api.nvim_input("<C-n>")
                else
                        vim.api.nvim_input("<C-x><C-o>")
               end
        end, opts)
		vim.keymap.set("i", "<S-Tab>", function()
                if vim.fn.pumvisible() then
                        vim.api.nvim_input("<C-p>")
                else
                        vim.api.nvim_input("<S-Tab>")
               end
        end, opts)
	end,
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
	},
})

-- Set up nvim-cmp.
-- local lsp_zero = require('lsp-zero')
-- local lsp_attach = function(client, bufnr)
--
--              -- Enable completion triggered by <c-x><c-o>
--              -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
--
--              -- Buffer local mappings.
--              -- See `:help vim.lsp.*` for documentation on any of the below functions
--              local opts = { buffer = bufnr }
--              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--              vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
--              vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
--              vim.keymap.set('n', '<leader>wl', function()
--                      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--              end, opts)
--              vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
--              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--              vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
--              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--              vim.keymap.set('n', '<leader>F', function()
--                      vim.lsp.buf.format { async = true }
--              end, opts)
-- end
-- lsp_zero.extend_lspconfig({
--      sign_text = true,
--      lsp_attach = lsp_attach,
--      capabilities = require('cmp_nvim_lsp').default_capabilities(),
-- })
--
-- local cmp = require('cmp')

-- local luasnip = require('luasnip')

-- cmp.setup({
--      snippet = {
--              -- REQUIRED - you must specify a snippet engine
--              expand = function(args)
--                      luasnip.lsp_expand(args.body)
--              end,
--      },
--      completion = {
--              completeopt = 'menu,menuone,preview'
--      },
--      preselect = 'None',
--      window = {
--              -- completion = cmp.config.window.bordered(),
--              -- documentation = cmp.config.window.bordered(),
--      },
--      mapping = cmp.mapping.preset.insert({
--              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--              ['<C-f>'] = cmp.mapping.scroll_docs(4),
--              ['<C-Space>'] = cmp.mapping.complete(),
--              ['<C-e>'] = cmp.mapping.abort(),
--              ['<Tab>'] = cmp.mapping(function(fallback)
--                      if cmp.visible() then
--                              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
--                      elseif luasnip.locally_jumpable(1) then
--                              luasnip.jump(1)
--                      else
--                              fallback()
--                      end
--              end, {"i", "s"}),
--              ['<S-Tab>'] = cmp.mapping(function(fallback)
--                      if cmp.visible() then
--                              cmp.select_prev_item()
--                      elseif luasnip.locally_jumpable(-1) then
--                              luasnip.jump(-1)
--                      else
--                              fallback()
--                      end
--              end, {"i", "s"}),
--              ['<CR>'] = cmp.mapping(function(fallback)
--                      if cmp.visible() then
--                              if luasnip.expandable() then
--                                      luasnip.expand()
--                              else
--                                      cmp.confirm({select = true})
--                              end
--                      else
--                              fallback()
--                      end
--              end, {"i", "s"}),
--      }),
--      sources = cmp.config.sources({
--              { name = 'nvim_lsp' },
--              { name = 'luasnip' }, -- For vsnip users.
--      }, {
--              { name = 'buffer' },
--      })
-- })
--
-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--      sources = cmp.config.sources({
--              { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
--      }, {
--              { name = 'buffer' },
--      })
-- })
--
-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--      mapping = cmp.mapping.preset.cmdline(),
--      sources = {
--              { name = 'buffer' }
--      }
-- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--      mapping = cmp.mapping.preset.cmdline(),
--      sources = cmp.config.sources({
--              { name = 'path' }
--      }, {
--              { name = 'cmdline' }
--      })
-- })
