-- LSP --

local status, nvim_lsp = pcall(require, "lspconfig")
if not status then
	return
end

local protocol = require("vim.lsp.protocol")

local setupKeymaps = function(client, bufnr)
	-- FIXME: These should be enabled I think, but they are not working
	-- vim.lsp_zero.default_keymaps({ buffer = bufnr })
	--	vim.lsp_zero.buf.format({ async = false, timeout = 10000 })
end

-- TypeScript
nvim_lsp.ts_ls.setup({
	on_attach = setupKeymaps,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
})

-- undefined global variable vim
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

require("lspconfig").ruff.setup({
	init_options = {
		settings = {
			-- Ruff language server settings go here
		},
	},
})
