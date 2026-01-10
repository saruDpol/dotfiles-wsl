return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- 💅 Formatters by filetype
			formatters_by_ft = {
				lua = { "stylua" }, -- Lua
				python = { "isort", "black" }, -- Python
				javascript = { "prettier" }, -- React Native JS
				typescript = { "prettier" }, -- React Native TS
				javascriptreact = { "prettier" }, -- React (JSX)
				typescriptreact = { "prettier" }, -- React (TSX)
			},

			-- ⚙️ Auto-format on save
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},
		})

		-- 🔧 Manual format keymap
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
