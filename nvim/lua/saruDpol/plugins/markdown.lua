return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install", -- build plugin after install
	ft = { "markdown" }, -- load only for markdown files
	config = function()
		-- Optional keymaps to open/close/toggle preview
		vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Open Markdown Preview" })
		vim.keymap.set("n", "<leader>mc", ":MarkdownPreviewStop<CR>", { desc = "Close Markdown Preview" })
		vim.keymap.set("n", "<leader>mt", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
	end,
}
