-- My Neovim configuration file
-- Author: Nick Nungester

-- features:
-- lsp
-- lazy loading via lazy
-- tree-sitter
-- fzf
-- lualine
-- mason
-- project.nvim
-- comment.nvim
-- prgmode
-- and more!
-- settings

--                        _
--  _ __   ___  _____   _(_)_ __ ___
-- | '_ \ / _ \/ _ \ \ / / | '_ ` _ \
-- | | | |  __/ (_) \ V /| | | | | | |
-- |_| |_|\___|\___/ \_/ |_|_| |_| |_|

require("settings")

-- vim.lsp.start({
-- 	name = "lua-language-server",
-- 	cmd = { "lua-language-server" },
-- 	root_dir = vim.fs.dirname(vim.fs.find({ ".git", ".vim", "nvim" }, { upward = true })[1]),
-- 	settings = { Lua = { diagnostics = { globals = { "vim" } } } },
-- })

-- set font
-- vim.opt.guifont = "FiraCode Nerd Font:h12"

local group_cdpwd = vim.api.nvim_create_augroup("group_cdpwd", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = group_cdpwd,
	pattern = "*",
	callback = function()
		vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- to update these, run `:Lazy update`
require("lazy").setup({
	-- keymappings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	-- mini is a collection of small plugins
	{
		"echasnovski/mini.nvim",
		version = "*",
	},
	-- visuals
	"nvim-lualine/lualine.nvim",
	"folke/tokyonight.nvim",
	"nvim-tree/nvim-web-devicons",
	-- searching
	"junegunn/fzf",
	"junegunn/fzf.vim",
	-- notes
	"nvim-orgmode/orgmode",
	--	"akinsho/org-bullets.nvim",
	{ "nvim-telescope/telescope-project.nvim", event = "VeryLazy" },
	{
		"jakewvincent/mkdnflow.nvim",
		config = function()
			require("mkdnflow").setup({
				-- Config goes here; leave blank for defaults
			})
		end,
	},
	-- project support
	"ahmedkhalf/project.nvim",
	-- commenting
	"numToStr/Comment.nvim",
	-- autocomplete
	"github/copilot.vim",

	-- the following are needed for lsp/structure
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"yaml",
					"html",
					"css",
					"prisma",
					"markdown",
					"markdown_inline",
					"svelte",
					"graphql",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
				},
			})
		end,
	},
	-- lsp packages
	{ "williamboman/mason.nvim" },
	-- lsp packages
	{ "williamboman/mason-lspconfig.nvim" },
	-- lsp packages
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
		},
	},
	-- END lsp packages

	-- autoformat: conform.nvim
	{
		"stevearc/conform.nvim",
		opts = {},
	},

	-- git integration: neogit a magit clone
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},

	-- terminal: toggleterm
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
	-- ai completion: oatmeal
	{
		"dustinblackman/oatmeal.nvim",
		cmd = { "Oatmeal" },
		keys = {
			{ "<leader>om", mode = "n", desc = "Start Oatmeal session" },
		},
		opts = {
			backend = "ollama",
			model = "codellama:latest",
		},
	},
})
-- keymappings
require("keymappings")

-- toggleterm
require("toggleterm").setup({
	size = 20,
})

-- Mason --
local lsp_zero = require("lsp-zero")
require("mason").setup()
require("mason-lspconfig").setup({
	handlers = { lsp_zero.default_setup },
	-- see the following link for more server configurations
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	ensure_installed = { "bashls", "lua_ls", "ts_ls", "rust_analyzer" },
})
lsp_zero.format_on_save = {
	servers = { "bashls", "lua_ls", "ts_ls", "rust_analyzer" },
}
-- LSP --
require("lsp")

-- TREE-SITTER --
require("nvim-treesitter.configs").setup({
	ensure_installed = { "typescript", "c", "lua", "vim", "vimdoc", "query" },
	sync_install = false,
	auto_install = true,
	ignore_install = { "go" },
	highlight = {
		enable = true,
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if (lang == "c") or (lang == "rust") then
				return true
			end
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = false,
	},
})

---------------------
-- plugin settings --
--------------------
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE', 'INFO', 'ERROR', 'WARNING' in comments
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		error = { pattern = "%f[%w]()ERROR()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		warning = { pattern = "%f[%w]()WARNING()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		info = { pattern = "%f[%w]()INFO()%f[%W]", group = "MiniHipatternsNote" },

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- projectile clone
require("project_nvim").setup({
	patterns = { ".git", ".git/", ".project", ".project/", ".projectile", "package.json", "Cargo.toml" },
	detection_methods = { "lsp", "pattern" },
	silent_chdir = true,
})
require("telescope").load_extension("projects")
-- lualine
require("plugins-lualine")

-- comment
require("Comment").setup({
	toggler = {
		line = "vl",
		block = "vg",
	},
	opleader = {
		line = "vl",
		block = "vg",
	},
})

-- orgmode
require("orgmode").setup({
	org_agenda_files = { "~/nvim/org/*" },
	org_default_notes_file = "~/nvim-notes/refile.org",
})

-- colors
require("colorscheme")
vim.cmd("colorscheme tokyonight-night")

-- icons

-- local icons = require("mini.icons")
-- icons.setup()

require("telescope")
