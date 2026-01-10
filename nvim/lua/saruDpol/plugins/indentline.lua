return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	config = function()
		-- Define custom scope highlight groups
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "ScopeRed", { fg = "#cb4a15" })
			vim.api.nvim_set_hl(0, "ScopePurple", { fg = "#6c71c4" })
			vim.api.nvim_set_hl(0, "ScopeGreen", { fg = "#859901" })
			vim.api.nvim_set_hl(0, "ScopeGold", { fg = "#ffc102" })
		end)
		require("ibl").setup({
			indent = {
				char = "▏",
			},
			scope = {
				enabled = true,
				highlight = {
					"ScopeGreen",
					"ScopePurple",
					"ScopeRed",
					"ScopeGold",
				},
				show_start = false,
				show_end = false,
				show_exact_scope = true,
				injected_languages = true,
			},
		})

		-- Set indent color to gold
	end,
}
