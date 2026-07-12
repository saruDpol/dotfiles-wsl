return {
	"esmuellert/codediff.nvim",

	cmd = "CodeDiff",

	keys = {
		{
			"<leader>gd",
			"<cmd>CodeDiff<cr>",
			desc = "CodeDiff: canvis del repositori",
		},
		{
			"<leader>gf",
			"<cmd>CodeDiff file HEAD<cr>",
			desc = "CodeDiff: fitxer contra HEAD",
		},
		{
			"<leader>gh",
			"<cmd>CodeDiff history<cr>",
			desc = "CodeDiff: historial",
		},
		{
			"<leader>gm",
			"<cmd>CodeDiff main...HEAD<cr>",
			desc = "CodeDiff: branca contra main",
		},
	},

	config = function()
		require("codediff").setup({
			highlights = {
				line_insert = "DiffAdd",
				line_delete = "DiffDelete",
				char_insert = nil,
				char_delete = nil,
				char_brightness = nil,
			},

			diff = {
				layout = "side-by-side",
				disable_inlay_hints = true,
				ignore_trim_whitespace = false,
				original_position = "left",
				jump_to_first_change = true,
				cycle_next_hunk = true,
				cycle_next_file = true,
				cycle_hunks_across_files = false,
				compute_moves = false,
				compact_context_lines = 3,
			},

			explorer = {
				position = "left",
				width = 40,
				hidden = false,
				auto_refresh = true,
				initial_focus = "explorer",
				auto_open_on_cursor = true, -- auto-open diff for file under cursor while moving
				auto_open_debounce_ms = 80, -- debounce window (ms) for the above
				flatten_dirs = true,
				indent_markers = true,
				file_filter = {
					ignore = {
						".git/**",
						".jj/**",
						"node_modules/**",
						"dist/**",
					},
				},
			},

			keymaps = {
				view = {
					next_hunk = "]c",
					prev_hunk = "[c",
					next_file = "]f",
					prev_file = "[f",
					diff_get = "do",
					diff_put = "dp",
					toggle_stage = "-",
					stage_hunk = "<leader>hs",
					unstage_hunk = "<leader>hu",
					discard_hunk = "<leader>hr",
					show_help = "g?",
					toggle_layout = "t",
					toggle_compact = "gc",
				},

				explorer = {
					select = "<CR>",
					hover = "K",
					refresh = "R",
					toggle_view_mode = "i",
					stage_all = "S",
					unstage_all = "U",
					restore = "X",
				},
			},
		})
	end,
}
