-- set leader key to space
vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "

--  _
-- | | _____ _   _ ___
-- | |/ / _ \ | | / __|
-- |   <  __/ |_| \__ \
-- |_|\_\___|\__, |___/
--           |___/
local wk = require("which-key")
local telebuiltin = require("telescope.builtin")
-- reload vimrc
wk.add({ { "<leader>h", group = "Help" } })
vim.api.nvim_set_keymap(
	"n",
	"<leader>hr",
	":source ~/.config/nvim/init.lua<CR>",
	{ noremap = true, desc = "Reload Vimrc" }
)

-- navigation like in emacs
vim.api.nvim_set_keymap("n", "<C-e>", "$", { noremap = true, desc = "End of Line" })
vim.api.nvim_set_keymap("n", "<C-a>", "^", { noremap = true, desc = "Start of Line" })

-- files
wk.add({ { "<leader>f", group = "File" } })
-- get files in current directory
vim.api.nvim_set_keymap("n", "<leader>fp", ":Files<CR>", { noremap = true, desc = "Find Files" })
vim.api.nvim_set_keymap("n", "<C-f>", ":Files<CR>", { noremap = true, desc = "Find Files (dup)" })
vim.api.nvim_set_keymap("n", "<C-p>", ":Files<CR>", { noremap = true, desc = "Find Files (dup)" })
vim.api.nvim_set_keymap("n", "<leader>ff", ":Files<CR>", { noremap = true, desc = "Find Files (dup)" })

-- other ways to find files
vim.api.nvim_set_keymap("n", "<leader>fd", ":Files %:p:h<CR>", { noremap = true, desc = "Find Files in Directory" })
vim.api.nvim_set_keymap("n", "<leader>fr", ":History<CR>", { noremap = true, desc = "Recent Files" })
vim.api.nvim_set_keymap("n", "<leader>fx", ":Ex<CR>", { noremap = true, desc = "Explore" })

-- save file
vim.api.nvim_set_keymap("n", "<leader>fs", ":w<CR>", { noremap = true, desc = "Save" })

-- buffers
wk.add({ { "<leader>b", group = "Buffers" } })
vim.api.nvim_set_keymap("n", "<leader>bb", ":Buffers<CR>", { noremap = true, desc = "Buffers" })
vim.api.nvim_set_keymap("n", "<leader>bp", ":bp<CR>", { noremap = true, desc = "Previous Buffer" })
vim.api.nvim_set_keymap("n", "<leader>bn", ":bn<CR>", { noremap = true, desc = "Next Buffer" })
vim.api.nvim_set_keymap("n", "<leader>bd", ":bd<CR>", { noremap = true, desc = "Delete Buffer" })
vim.api.nvim_set_keymap("n", "<leader>br", ":edit!<CR>", { noremap = true, desc = "Revert Buffer" })

-- code
wk.add({ { "<leader>c", group = "Code" } })
-- vim.api.nvim_set_keymap("n", "<leader>cf", ":LspZeroFormat<CR>", { noremap = true, desc = "Format" })
vim.api.nvim_set_keymap("n", "<leader>cr", ":Rg<CR>", { noremap = true, desc = "Rg" })
vim.api.nvim_set_keymap("n", "<leader>ct", ":Tags<CR>", { noremap = true, desc = "Tags" })
vim.api.nvim_set_keymap("n", "<leader>cm", ":Marks<CR>", { noremap = true, desc = "Marks" })
vim.api.nvim_set_keymap("n", "<leader>cg", ":Neogit<CR>", { noremap = true, desc = "Neogit" })
vim.keymap.set("n", "<leader>cd", telebuiltin.lsp_definitions, { desc = "LSP Definitions" })
vim.api.nvim_set_keymap("n", "<leader>ck", ":LspInfo<CR>", { noremap = true, silent = true, desc = "LSP Info" })

-- custom
wk.add({ { "<leader>v", group = "Custom" } })

-- comment line
vim.api.nvim_set_keymap("n", "<leader>vl", ":Lsp.Comment.Line <CR>", { noremap = true, desc = "Comment Line" })
vim.api.nvim_set_keymap("n", "<leader>vj", ":! gitjump <CR>", { noremap = true, desc = "gitjump" })

-- git
wk.add({ { "<leader>g", group = "Git" } })
vim.api.nvim_set_keymap("n", "<leader>gg", ":Neogit<CR>", { noremap = true, desc = "Neogit" })

-- searching aliases
wk.add({ { "<leader>s", group = "Search" } })
vim.api.nvim_set_keymap("n", "<leader>sr", ":Rg<CR>", { noremap = true, desc = "Rg" })
vim.keymap.set("n", "<leader>sf", telebuiltin.live_grep, { desc = "Live Grep" })

-- term
wk.add({ { "<leader>o", group = "Open" } })
vim.api.nvim_set_keymap("n", "<leader>ot", ":ToggleTerm<CR>", { noremap = true, desc = "Toggle Terminal" })
vim.api.nvim_set_keymap(
	"t",
	"<Esc><leader>ot",
	"<C-\\><C-n><CMD>ToggleTerm<CR>",
	{ noremap = true, desc = "Toggle Terminal" }
)

-- projects
wk.add({ { "<leader>p", group = "Projects" } })
vim.api.nvim_set_keymap("n", "<leader>pp", ":Telescope projects<CR>", { noremap = true, desc = "Projects" })

-- windows
wk.add({ { "<leader>w", group = "Windows" } })
vim.api.nvim_set_keymap("n", "<leader>wv", ":vsplit<CR>", { noremap = true, desc = "Vertical Split" })
vim.api.nvim_set_keymap("n", "<leader>wh", ":split<CR>", { noremap = true, desc = "Horizontal Split" })
vim.api.nvim_set_keymap("n", "<leader>wd", ":q!<CR>", { noremap = true, desc = "Close Window" })

-- telescope
wk.add({ { "<leader>t", group = "Telescope" } })
vim.keymap.set("n", "<leader>tf", telebuiltin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>tg", telebuiltin.git_files, { desc = "Git Files" })
vim.keymap.set("n", "<leader>ts", telebuiltin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>tb", telebuiltin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>th", telebuiltin.help_tags, { desc = "Help Tags" })
