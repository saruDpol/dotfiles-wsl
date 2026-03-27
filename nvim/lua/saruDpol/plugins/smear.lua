return {
	"sphamba/smear-cursor.nvim",
	opts = {
		-- Smear config options here:
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,
		scroll_buffer_space = true,

		-- Animation
		smear_insert_mode = false,
		smear_to_cmd = true,
		cursor_color = false,

		-- Timing / feel
		stiffness = 0.4,
		trailing_stiffness = 0.6,
		distance_stop_animating = 0.8,

		-- Legacy / optional
		hide_target_hack = true,
	},
	config = function(_, opts)
		require("smear_cursor").setup(opts)

		-- Optional toggle keymap
		vim.keymap.set("n", "<leader>us", function()
			require("smear_cursor").toggle()
		end, { desc = "Toggle Smear Cursor" })
	end,
}
