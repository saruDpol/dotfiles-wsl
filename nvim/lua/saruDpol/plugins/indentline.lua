return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	config = function()
		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "ScopeRed", { fg = "#cb4a15" })
			vim.api.nvim_set_hl(0, "ScopePurple", { fg = "#6c71c4" })
			vim.api.nvim_set_hl(0, "ScopeGreen", { fg = "#859901" })
			vim.api.nvim_set_hl(0, "ScopeGold", { fg = "#ffc102" })
			vim.api.nvim_set_hl(0, "ScopeBlue", { fg = "#268bd2" })
			vim.api.nvim_set_hl(0, "ScopeCyan", { fg = "#2aa198" })
			vim.api.nvim_set_hl(0, "ScopeOrange", { fg = "#d07020" })
			vim.api.nvim_set_hl(0, "ScopePink", { fg = "#d33682" })
		end)

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, function(_, bufnr, scope, scope_index)
			local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype) or vim.bo[bufnr].filetype

			if lang ~= "python" then
				return scope_index
			end

			local start_row, start_col = scope:start()
			local highlight_count = 8
			return (start_row * 3 + start_col) % highlight_count + 1
		end)

		require("ibl").setup({
			indent = {
				char = vim.fn.nr2char(0x258F),
			},
			scope = {
				enabled = true,
				highlight = {
					"ScopeGreen", -- 1
					"ScopePurple", -- 2
					"ScopeRed", -- 3
					"ScopeGold", -- 4
					"ScopeBlue", -- 5
					"ScopeCyan", -- 6
					"ScopeOrange", -- 7
					"ScopePink", -- 8
				},
				show_start = false,
				show_end = false,
				show_exact_scope = true,
				injected_languages = true,
				include = {
					node_type = {
						python = {
							"block",
							"if_statement",
							"elif_clause",
							"else_clause",
							"for_statement",
							"while_statement",
							"function_definition",
							"class_definition",
							"with_statement",
							"try_statement",
							"except_clause",
							"finally_clause",
							"decorated_definition",
							"match_statement",
							"case_clause",
						},
					},
				},
			},
		})
	end,
}
