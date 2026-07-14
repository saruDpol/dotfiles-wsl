return {
	{
		"saruDpol/seijaku-nvim",
		main = "seijaku",
		lazy = false,
		opts = {
			vault_dir = "~/Notes/seijaku",
			sidebar = {
				width = "auto",
				default_mode = "directory",
				default_all_sort = "date",
			},
			editor = {
				wrap = true,
				linebreak = true,
				breakindent = true,
			},
			keymaps = {
				enable_default = true,
				toggle = "<A-o>",
				new_for_current = "<leader>a",
			},
		},
	},
}
