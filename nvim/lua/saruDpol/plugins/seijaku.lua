return {
<<<<<<< HEAD
	dir = "/home/sarudpol/main/seijaku",
	name = "seijaku.nvim",
	lazy = false,

	config = function()
		require("seijaku").setup({
			vault_dir = "~/Notes/seijaku",

			keymaps = {
				enable_default = true,
				toggle = "<A-o>",
			},
		})
	end,
=======
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
>>>>>>> dd3ecb5 (seijaku added)
}
