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
	opt.termguicolors = true
	opt.showmode = false
	opt.cmdheight = 0
end

do
	local wo = vim.wo
	wo.wrap = false
end

do
	local set = vim.keymap.set
	set("n", "<leader>e", "<cmd>Neotree toggle<cr>")
	set("n", "<leader>f", vim.lsp.buf.format)
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
			config = function()
				require('which-key').setup()
			end
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
			}
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
						ignore_focus = { 'neo-tree' },
						always_divide_middle = true,
						globalstatus = true,
						refresh = {
							statusline = 1000,
							tabline = 1000,
							winbar = 1000,
						}
					},
					sections = {
						lualine_a = { 'mode' },
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
				require("bufferline").setup {}
			end
		},
		{
			"petertriho/nvim-scrollbar",
			config = function()
				require("scrollbar").setup()
			end
		},
		"neovim/nvim-lspconfig",
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end
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
						local config = {}

						if server_name == "denols" then
							config = {
								on_attach = on_attach,
								root_dir = lspconfig.util.root_pattern("deno.json",
									"deno.jsonc"),
							}
						elseif server_name == "tsserver" then
							config = {
								on_attach = on_attach,
								root_dir = lspconfig.util.root_pattern("package.json"),
								single_file_support = false
							}
						end

						lspconfig[server_name].setup(config)
					end
				}
			end
		},
	}
end
