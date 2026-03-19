return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	config = function()
		local hooks = require("ibl.hooks")

		-- highlight groups
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "ScopeRed", { fg = "#cb4a15" })
			vim.api.nvim_set_hl(0, "ScopePurple", { fg = "#6c71c4" })
			vim.api.nvim_set_hl(0, "ScopeGreen", { fg = "#859901" })
			vim.api.nvim_set_hl(0, "ScopeGold", { fg = "#ffc102" })
		end)

		require("ibl").setup({
			indent = {
				char = vim.fn.nr2char(0x258F),
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

				-- ? FIX FOR PYTHON
				include = {
					node_type = {
						python = {
							"if_statement",
							"for_statement",
							"while_statement",
							"function_definition",
							"class_definition",
							"with_statement",
							"try_statement",
						},
					},
				},
			},
		})
	end,
}
