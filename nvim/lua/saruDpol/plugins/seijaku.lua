return {
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
}
