return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
		config = function(_, opts)
			require("solarized-osaka").setup(opts)
			local theme_mode = require("saruDpol.theme_mode")
			theme_mode.apply(true)
			theme_mode.setup()
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			theme = "wave",
			background = {
				dark = "wave",
				light = "lotus",
			},
		},
		config = function(_, opts)
			require("kanagawa").setup(opts)
		end,
	},
	{
		"savq/melange-nvim",
		lazy = false,
		priority = 1000,
	},
}
