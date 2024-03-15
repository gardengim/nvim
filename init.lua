do
	local g = vim.g
	g.mapleader = " "
	g.maplocalleader = "\\"
end

do
	local opt = vim.opt
	opt.number = true
	opt.relativenumber = true
	opt.signcolumn = "number"
	opt.cursorline = true
	opt.tabstop = 4
	opt.shiftwidth = 4
	opt.termguicolors = true
	opt.showmode = false
	opt.cmdheight = 0
end

do
	local wo = vim.wo
	wo.wrap = false
end


do
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end

do
	require("lazy").setup {
		{
			"folke/which-key.nvim",
			config = true
		},
		{
			"rebelot/kanagawa.nvim",
			config = function()
				vim.cmd("colorscheme kanagawa")
			end
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
			},
			config = function()
				vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>")
			end
		},
		{
			'akinsho/toggleterm.nvim',
			version = "*",
			config = function()
				require("toggleterm").setup()
				vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>")

				do
					local Terminal = require('toggleterm.terminal').Terminal
					local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true })

					vim.keymap.set("n", "<leader>g", function() lazygit:toggle() end,
						{ desc = "Toggle LaztGit" })
				end
			end
		},
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				require('lualine').setup {
					options = {
						icons_enabled = true,
						theme = 'auto',
						component_separators = { left = '', right = '' },
						section_separators = { left = '', right = '' },
						disabled_filetypes = {
							statusline = {},
							winbar = {},
						},
						ignore_focus = { 'neo-tree', 'toggleterm' },
						always_divide_middle = true,
						globalstatus = true,
						refresh = {
							statusline = 1000,
							tabline = 1000,
							winbar = 1000,
						}
					},
					sections = {
						lualine_a = {
							{
								'mode',
								fmt = function(str)
									return str:sub(1, 1)
								end
							}
						},
						lualine_b = { 'branch', 'diff', 'diagnostics' },
						lualine_c = {},
						lualine_x = { 'encoding' },
						lualine_y = { 'filetype' },
						lualine_z = { 'location' }
					},
					inactive_sections = {},
					tabline = {},
					winbar = {},
					inactive_winbar = {},
					extensions = {}
				}
			end
		},
		{
			'akinsho/bufferline.nvim',
			version = "*",
			dependencies = 'nvim-tree/nvim-web-devicons',
			config = function()
				local bufferline = require("bufferline");
				bufferline.setup()
				vim.keymap.set("n", "<leader>1", function() bufferline.go_to(1, true) end, {desc = "Go to 1st buffer"})
				vim.keymap.set("n", "<leader>2", function() bufferline.go_to(2, true) end, {desc = "Go to 2nd buffer"})
				vim.keymap.set("n", "<leader>3", function() bufferline.go_to(3, true) end, {desc = "Go to 3rd buffer"})
				vim.keymap.set("n", "<leader>4", function() bufferline.go_to(4, true) end, {desc = "Go to 4th buffer"})
				vim.keymap.set("n", "<leader>5", function() bufferline.go_to(5, true) end, {desc = "Go to 5th buffer"})
				vim.keymap.set("n", "<leader>6", function() bufferline.go_to(6, true) end, {desc = "Go to 6th buffer"})
				vim.keymap.set("n", "<leader>7", function() bufferline.go_to(7, true) end, {desc = "Go to 7th buffer"})
				vim.keymap.set("n", "<leader>8", function() bufferline.go_to(8, true) end, {desc = "Go to 8th buffer"})
				vim.keymap.set("n", "<leader>9", function() bufferline.go_to(9, true) end, {desc = "Go to 9th buffer"})
				vim.keymap.set("n", "<leader>0", function() bufferline.go_to(-1, true) end, {desc = "Go to the last buffer"})
			end
		},
		{
			"petertriho/nvim-scrollbar",
			config = true
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
			config = function()
				require("noice").setup({
					lsp = {
						override = {
							["vim.lsp.util.convert_input_to_markdown_lines"] = true,
							["vim.lsp.util.stylize_markdown"] = true,
							["cmp.entry.get_documentation"] = true,
						},
					},
					cmdline = {
						view = "cmdline"
					}
				})
			end
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			opts = {
				scope = {
					enabled = true
				}
			},
			config = true
		},
		{
			'vladdoster/remember.nvim',
			config = true
		},
		{
			'rmagatti/auto-session',
			config = function()
				require("auto-session").setup {
					log_level = "error",
				}
			end
		},
		{
			'windwp/nvim-autopairs',
			event = "InsertEnter",
			config = true
		},
		{
			'nvim-treesitter/nvim-treesitter',
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "rust", "toml" },
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end
		},
		"neovim/nvim-lspconfig",
		{
			"williamboman/mason.nvim",
			config = true
		},
		{
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup {
					ensure_installed = {
						"denols",
						"lua_ls",
						"rust_analyzer",
						"tsserver"
					},
				}
				require("mason-lspconfig").setup_handlers {
					function(server_name)
						local lspconfig = require("lspconfig")

						local config = {
							on_attach = on_attach,
							compatibilities = require('cmp_nvim_lsp').default_capabilities()
						}

						if server_name == "denols" then
							config.root_dir = lspconfig.util.root_pattern("deno.json",
								"deno.jsonc")
						elseif server_name == "tsserver" then
							config.root_dir = lspconfig.util.root_pattern("package.json")
							config.single_file_support = false
						end

						lspconfig[server_name].setup(config)
						vim.keymap.set("n", "<leader>F", vim.lsp.buf.format,
							{ desc = "LSP Format" })
					end
				}
			end
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-cmdline',
				'hrsh7th/nvim-cmp',
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip'
			},
			config = function()
				local cmp = require 'cmp'

				cmp.setup({
					snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end,
					},
					completion = { completeopt = 'menu,menuone,noinsert' },
					mapping = cmp.mapping.preset.insert({
						['<C-b>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						['<C-Space>'] = cmp.mapping.complete(),
						['<C-e>'] = cmp.mapping.abort(),
						['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					}),
					sources = cmp.config.sources({
						{ name = 'nvim_lsp' },
						{ name = 'luasnip' }
					}, {
						{ name = 'buffer' },
					})
				})

				cmp.setup.filetype('gitcommit', {
					sources = cmp.config.sources({
						{ name = 'git' }
					}, {
						{ name = 'buffer' },
					})
				})

				cmp.setup.cmdline({ '/', '?' }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = 'buffer' }
					}
				})

				cmp.setup.cmdline(':', {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = 'path' }
					}, {
						{ name = 'cmdline' }
					})
				})
			end
		}
	}
end
