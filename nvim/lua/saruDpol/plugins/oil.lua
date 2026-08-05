return {
	"stevearc/oil.nvim",
	opts = {
		-- Oil config options here:
		columns = {
			"icon",
			-- "mtime",
		},
		use_default_keymaps = true,
		view_options = {
			show_hidden = true,
			is_always_compatible = false,
		},
		float = {
			padding = 2,
			max_width = 80,
			max_height = 40,
			border = "rounded",
		},
	},
	config = function(_, opts)
		-- Add override_explorer to opts table without losing existing opts
		opts.override_explorer = false
		require("oil").setup(opts)

		-- Optional keymap to open Oil manually
		vim.keymap.set("n", "<leader><leader>", require("oil").open, { desc = "Open Oil" })
	end,
}
