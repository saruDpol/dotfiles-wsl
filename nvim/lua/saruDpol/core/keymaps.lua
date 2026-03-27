local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- =========================================================
-- 🖥️ GENERAL
-- =========================================================

-- Exit terminal mode with <Esc>
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Delete a word backwards
keymap.set("n", "dw", "vb_d", opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Disable 's' globally (often used by plugins like netrw)
keymap.set("n", "s", "<Nop>", opts)

-- =========================================================
-- 🗂️ NETRW (File Explorer)
-- =========================================================

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		keymap.set("n", "s", "<Nop>", { buffer = true })
		keymap.set("n", "S", "<Plug>NetrwSortBy", { buffer = true, silent = true })
	end,
})

-- =========================================================
-- 🧭 NAVIGATION
-- =========================================================

-- Jump back and forward through jumplist
keymap.set("n", "<C-n>", "<C-o>", opts) -- older position
keymap.set("n", "<C-m>", "<C-i>", opts) -- newer position

-- Keep cursor centered when scrolling
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
-- keymap.set("n", "<C-b>", "<C-b>zz", { desc = "Page up and center" })
keymap.set("n", "<C-b>", "<C-b>", { desc = "Page up" })

-- Scroll padding
vim.o.scrolloff = 8

-- =========================================================
-- 🪟 WINDOW MANAGEMENT
-- =========================================================

-- Split windows
keymap.set("n", "ss", ":split<CR>", opts)
keymap.set("n", "sv", ":vsplit<CR>", opts)

-- Move between windows with Alt + hjkl
keymap.set("n", "<M-h>", "<C-w>h", opts)
keymap.set("n", "<M-j>", "<C-w>j", opts)
keymap.set("n", "<M-k>", "<C-w>k", opts)
keymap.set("n", "<M-l>", "<C-w>l", opts)

-- Resize windows with Alt + Arrow Keys
vim.keymap.set("n", "<M-w>", ":resize -2<CR>", opts) -- up
vim.keymap.set("n", "<M-s>", ":resize +2<CR>", opts) -- down
vim.keymap.set("n", "<M-a>", ":vertical resize -2<CR>", opts) -- left
vim.keymap.set("n", "<M-d>", ":vertical resize +2<CR>", opts) -- right

-- =========================================================
-- 📂 FILE EXPLORER / DASHBOARD
-- =========================================================

-- Open Netrw
keymap.set("n", "<leader><leader>", vim.cmd.Ex, { desc = "Open file explorer" })

-- Open Alpha dashboard
keymap.set("n", "<leader>aa", function()
	require("alpha").start()
end, { desc = "Open Alpha Dashboard" })

-- =========================================================
-- 📋 CLIPBOARD & EDITING
-- =========================================================
-- mantenir seleccio visual despres d'indentar
--
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Yank to system clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
keymap.set("n", "<leader>Y", '"+Y', opts)

-- Paste from system clipboard
keymap.set({ "n", "v" }, "<leader>p", '"+p', opts)
keymap.set("n", "<leader>P", '"+P', opts)

-- Delete without copying to clipboard
keymap.set({ "n", "v" }, "<leader>d", '"_d', opts)

-- Replace selection without copying
keymap.set("v", "p", '"_dP', opts)

-- Visual block shortcut
keymap.set("n", "<leader>v", "<C-q>", { desc = "Enter Visual Block mode" })

-- Optional: delete single character without copying
vim.keymap.set("n", "x", '"_x', opts)

-- Optional: change without copying
vim.keymap.set("n", "c", '"_c', opts)

-- Delete a whole line without affecting the clipboard
vim.keymap.set("n", "dd", '"_dd', { noremap = true, silent = true })

-- =========================================================
-- 🧠 LSP & TELESCOPE
-- =========================================================

-- Hover info
keymap.set("n", "<C-h>", vim.lsp.buf.hover, { desc = "Show hover info" })

-- Go to next diagnostic
keymap.set("n", "<C-j>", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Telescope: Go to definition
keymap.set("n", "<C-k>", function()
	require("telescope.builtin").lsp_definitions({
		layout_strategy = "vertical",
		layout_config = { preview_height = 0.6 },
	})
end, { desc = "Go to Definition (Telescope)" })

-- Telescope: Find references
keymap.set("n", "<leader>gr", function()
	require("telescope.builtin").lsp_references()
end, { desc = "Find References (Telescope)" })
