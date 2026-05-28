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
	-- using telescope-project.nvim (loaded above)
	-- commenting
	"numToStr/Comment.nvim",
	-- autocomplete
	"github/copilot.vim",

	-- the following are needed for lsp/structure
	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	build = ":TSUpdate",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		local treesitter = require("nvim-treesitter.configs")
	-- 		treesitter.setup({ -- enable syntax highlighting
	-- 			highlight = {
	-- 				enable = true,
	-- 			},
	-- 			-- enable indentation
	-- 			indent = { enable = true },
	-- 			ensure_installed = {
	-- 				"json",
	-- 				"javascript",
	-- 				"typescript",
	-- 				"tsx",
	-- 				"yaml",
	-- 				"html",
	-- 				"css",
	-- 				"prisma",
	-- 				"markdown",
	-- 				"markdown_inline",
	-- 				"svelte",
	-- 				"graphql",
	-- 				"bash",
	-- 				"lua",
	-- 				"vim",
	-- 				"dockerfile",
	-- 				"gitignore",
	-- 				"query",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		opts = function()
			-- Register nvim-cmp lsp capabilities
			vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			local auto_select = true
			return {
				auto_brackets = {}, -- configure any filetype to auto add brackets
				completion = {
					completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
				},
				preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-CR>"] = function(fallback)
						cmp.abort()
						fallback()
					end,
					-- ["<tab>"] = function(fallback)
					--     return cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
					-- end,
					-- }),

					["<tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "lazydev" },
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = function(entry, item)
						-- local icons = LazyVim.config.icons.kinds
						-- if icons[item.kind] then
						-- item.kind = icons[item.kind] .. item.kind
						-- end

						local widths = {
							abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
							menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
						}

						for key, width in pairs(widths) do
							if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
								item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
							end
						end

						return item
					end,
				},
				experimental = {
					-- only show ghost text when we show ai completions
					ghost_text = vim.g.ai_cmp and {
						hl_group = "CmpGhostText",
					} or false,
				},
				sorting = defaults.sorting,
			}
		end,
	},

	-- lsp packages
	{ "williamboman/mason.nvim" },
	-- lsp packages
	{ "williamboman/mason-lspconfig.nvim" },
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
		opts = {
			shell = vim.o.shell,
		},
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

-- LSP --
vim.filetype.add({ extension = { ron = "ron" } })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "ron",
	callback = function() vim.bo.syntax = "rust" end,
})
vim.lsp.config("ron_lsp", {
	cmd = { "ron-lsp" },
	filetypes = { "ron" },
	root_markers = { "Cargo.toml", ".git" },
})
vim.lsp.enable("ron_lsp")
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
vim.lsp.enable("lua_ls")
-- TypeScript
vim.lsp.config("ts", {
	on_attach = setupKeymaps,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
})
vim.lsp.enable("ts")

---------------------
-- plugin settings --
--------------------
--------------------
require("telescope")
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
require("telescope").load_extension("project")
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
